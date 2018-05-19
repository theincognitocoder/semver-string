# frozen_string_literal: true

module Semver
  # @api private
  class Identifier

    # @param [String, Integer] value
    def initialize(value)
      @value = value
    end

    # @return [String, Integer]
    attr_reader :value

    # @return [Integer] Returns -1, 0, or 1.
    def <=>(other)
      if other.value.is_a?(value.class)
        value <=> other.value
      elsif value.is_a?(Integer)
        -1
      else
        1
      end
    end

    # @param [String] value
    def self.new(value)
      identifier = allocate
      identifier.send(:initialize, value =~ /^\d+$/ ? value.to_i : value)
      identifier
    end

  end
end
