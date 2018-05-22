# frozen_string_literal: true

module Semver
  # @api private
  class Parser

    PATTERN = %r{^
      (0|[1-9]\d*)\. # major
      (0|[1-9]\d*)\. # minor
      (0|[1-9]\d*)   # patch
      (-             # pre release
        (0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)
        (\.(0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*
      )?
      (\+[0-9a-zA-Z-]+(\.[0-9a-zA-Z-]+)*)? # build metadata
    $}x

    def parse(string)
      matches = PATTERN.match(string.to_s)
      raise InvalidFormatError, string unless matches
      {
        major: matches[1].to_i,
        minor: matches[2].to_i,
        patch: matches[3].to_i,
        pre_release: left_chop(matches[4]),
        build_metadata: left_chop(matches[8]),
      }
    end

    private

    def left_chop(value)
      value ? value[1..-1] : nil
    end

  end
end
