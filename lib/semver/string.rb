# frozen_string_literal: true

require_relative 'comparator'
require_relative 'identifier'
require_relative 'invalid_format_error'
require_relative 'parser'

module Semver
  # A helper class for working with semantic versioning strings.
  #
  # ```ruby
  # version = Semver::String.new('1.2.3-alpha+build-123')
  #
  # version.major #=> 1
  # version.major #=> 2
  # version.patch #=> 3
  # version.pre_release #=> alpha
  # version.build_metadata #=> build-123
  # version.to_s #=> "1.2.3-alpha+build-123"
  # ```
  #
  class String

    # @param [String] string
    # @return [Version]
    def self.parse(string)
      semver = allocate
      semver.send(:initialize, Parser.new.parse(string))
      semver
    end

    # @param [Integer] major
    # @param [Integer] minor
    # @param [Integer] patch
    # @param [String,nil] pre_release
    # @param [String,nil] build_metadata
    def initialize(
      major:,
      minor:,
      patch:,
      pre_release: nil,
      build_metadata: nil
    )
      @major = major
      @minor = minor
      @patch = patch
      @pre_release = pre_release
      @build_metadata = build_metadata
      @string = format_string
    end

    # @return [Integer]
    attr_reader :major

    # @return [Integer]
    attr_reader :minor

    # @return [Integer]
    attr_reader :patch

    # @return [String, nil]
    attr_reader :pre_release

    # @return [String, nil]
    attr_reader :build_metadata

    # @return [String]
    def to_str
      @string
    end
    alias to_s to_str

    # @return [Boolean]
    # @api private
    def eql?(other)
      if other.is_a?(Semver::String)
        to_str == other.to_str
      else
        false
      end
    end

    # @return [Boolean] Returns `true` if the string value of the
    #   two objects are equal.
    def ==(other)
      to_s == other.to_s
    end

    # See section #11 of https://semver.org/spec/v2.0.0.html
    # @return [Integer] Returns -1, 0, or 1.
    def <=>(other)
      Comparator.new.compare(left: self, right: other)
    end

    private

    def format_string
      string = [major, minor, patch].join('.')
      string += "-#{pre_release}" if pre_release
      string += "+#{build_metadata}" if build_metadata
      string
    end

  end
end
