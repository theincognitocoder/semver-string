require_relative 'spec_helper'

RSpec.describe SemverString do
  context '.new' do

    it 'parses semver strings with pre-release' do
      version = SemverString.new('1.2.3-alpha.4')
      expect(version.x).to eq(1)
      expect(version.y).to eq(2)
      expect(version.z).to eq(3)
      expect(version.pre_release).to eq('alpha.4')
    end

    it 'parses semver strings with build metadata' do
      version = SemverString.new('1.2.3+20130313144700')
      expect(version.x).to eq(1)
      expect(version.y).to eq(2)
      expect(version.z).to eq(3)
      expect(version.build_metadata).to eq('20130313144700')
    end

    it 'parses semver strings with pre-release and build metadata' do
      version = SemverString.new('1.2.3-alpha.4+20130313144700')
      expect(version.x).to eq(1)
      expect(version.y).to eq(2)
      expect(version.z).to eq(3)
      expect(version.pre_release).to eq('alpha.4')
      expect(version.build_metadata).to eq('20130313144700')
    end

    it 'throws when nil' do
      expect do
        SemverString.new(nil)
      end.to raise_error(SemverString::InvalidFormatError)
    end

    it 'throws when empty' do
      expect do
        SemverString.new('')
      end.to raise_error(SemverString::InvalidFormatError)
    end

    it 'throws when missing .z' do
      expect do
        SemverString.new('1.2')
      end.to raise_error(SemverString::InvalidFormatError)
    end

    it 'throws for non-valid semver characters' do
      expect do
        SemverString.new('1.2.3-beta!')
      end.to raise_error(SemverString::InvalidFormatError)
    end

  end

  context '#<=>' do

   it 'sorts version strings according to semver' do
     versions = []
     versions << SemverString.new('1.0.0-alpha')
     versions << SemverString.new('1.0.0-alpha.1')
     versions << SemverString.new('1.0.0-alpha.1.beta.gamma')
     versions << SemverString.new('1.0.0-alpha.beta')
     versions << SemverString.new('1.0.0-alpha.beta.1')
     versions << SemverString.new('1.0.0-beta')
     versions << SemverString.new('1.0.0-beta.2')
     versions << SemverString.new('1.0.0-beta.11')
     versions << SemverString.new('1.0.0-rc.1')
     versions << SemverString.new('1.0.0')
     expect(versions.shuffle.sort).to eq(versions)
   end

   it 'sorts ignores build metadata' do
     v1 = SemverString.new('1.0.0+build-123')
     v2 = SemverString.new('1.0.0+build-456')
     expect(v1 <=> v2).to eq(0)
   end

  end
end
