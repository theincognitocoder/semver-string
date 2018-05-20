# frozen_string_literal: true

RSpec.describe Semver::String do
  context '.parse' do
    it 'parses semver strings with pre-release' do
      version = Semver::String.parse('1.2.3-alpha.4')
      expect(version.major).to eq(1)
      expect(version.minor).to eq(2)
      expect(version.patch).to eq(3)
      expect(version.pre_release).to eq('alpha.4')
    end

    it 'parses semver strings with build metadata' do
      version = Semver::String.parse('1.2.3+20130313144700')
      expect(version.major).to eq(1)
      expect(version.minor).to eq(2)
      expect(version.patch).to eq(3)
      expect(version.build_metadata).to eq('20130313144700')
    end

    it 'parses semver strings with pre-release and build metadata' do
      version = Semver::String.parse('1.2.3-alpha.4+20130313144700')
      expect(version.major).to eq(1)
      expect(version.minor).to eq(2)
      expect(version.patch).to eq(3)
      expect(version.pre_release).to eq('alpha.4')
      expect(version.build_metadata).to eq('20130313144700')
    end

    it 'throws when nil' do
      expect do
        Semver::String.parse(nil)
      end.to raise_error(Semver::InvalidFormatError)
    end

    it 'throws when empty' do
      expect do
        Semver::String.parse('')
      end.to raise_error(Semver::InvalidFormatError)
    end

    it 'throws when missing patch' do
      expect do
        Semver::String.parse('1.2')
      end.to raise_error(Semver::InvalidFormatError)
    end

    it 'throws for non-valid semver characters' do
      expect do
        Semver::String.parse('1.2.3-beta!')
      end.to raise_error(Semver::InvalidFormatError)
    end
  end

  context '#<=>' do
    it 'sorts version strings according to semver' do
      versions = []
      versions << Semver::String.parse('1.0.0-alpha')
      versions << Semver::String.parse('1.0.0-alpha.1')
      versions << Semver::String.parse('1.0.0-alpha.1.beta.gamma')
      versions << Semver::String.parse('1.0.0-alpha.beta')
      versions << Semver::String.parse('1.0.0-alpha.beta.1')
      versions << Semver::String.parse('1.0.0-beta')
      versions << Semver::String.parse('1.0.0-beta.2')
      versions << Semver::String.parse('1.0.0-beta.11')
      versions << Semver::String.parse('1.0.0-rc.1')
      versions << Semver::String.parse('1.0.0')
      expect(versions.shuffle.sort).to eq(versions)
    end

    it 'compares numerical pre-release identifiers low-to-high' do
      v1 = Semver::String.parse('1.0.0-rc.2')
      v2 = Semver::String.parse('1.0.0-rc.10')
      expect(v1 <=> v2).to eq(-1)
      expect(v2 <=> v1).to eq(1)
    end

    it 'compares alpha pre-release identifiers lexicographically' do
      v1 = Semver::String.parse('1.0.0-alpha10')
      v2 = Semver::String.parse('1.0.0-alpha2')
      expect(v1 <=> v2).to eq(-1)
      expect(v2 <=> v1).to eq(1)
    end

    it 'sorts ignores build metadata' do
      v1 = Semver::String.parse('1.0.0+build-123')
      v2 = Semver::String.parse('1.0.0+build-456')
      expect(v1 <=> v2).to eq(0)
    end
  end

  context '#eql?' do
    it 'returns true for equal Semver::String values' do
      version1 = Semver::String.parse('1.2.3-rc.1+build1')
      version2 = Semver::String.parse('1.2.3-rc.1+build1')
      expect(version1).to eql(version2)
      expect(version2).to eql(version1)
    end

    it 'returns false for non-equal Semver::String values' do
      version1 = Semver::String.parse('1.2.3-rc.1+build1')
      version2 = '1.2.3'
      expect(version1).not_to eql(version2)
      expect(version2).not_to eql(version1)
    end
  end

  context '#==' do
    it 'returns true for equal strings' do
      version1 = Semver::String.parse('1.2.3-rc.1+build1')
      version2 = '1.2.3-rc.1+build1'
      expect(version1).to eq(version2)
      expect(version2).to eq(version1)
    end

    it 'returns false for non-equal strings' do
      version1 = Semver::String.parse('1.2.3-rc.1+build1')
      version2 = '1.2.3'
      expect(version1).not_to eq(version2)
      expect(version2).not_to eq(version1)
    end
  end

  context '.to_s' do
    it 'formats the string as a semver version' do
      version = Semver::String.new(
        major: 1,
        minor: 2,
        patch: 3,
        pre_release: 'rc.1',
        build_metadata: 123_456_789
      )
      expect(version.to_s).to eq('1.2.3-rc.1+123456789')
    end
  end
end
