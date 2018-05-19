# frozen_string_literal: true

module Semver
  # @api private
  class Comparator

    # @param [Semver::String] left
    # @param [Semver::String] right
    def compare(left:, right:)
      parts(left) <=> parts(right)
    end

    def parts(semver)
      [semver.major, semver.minor, semver.patch] + pre_release(semver)
    end

    def pre_release(semver)
      if semver.pre_release
        [-1] + pre_release_identifiers(semver)
      else
        [1]
      end
    end

    def pre_release_identifiers(semver)
      semver.pre_release.split('.').map { |value| Identifier.new(value) }
    end

  end
end
