# frozen_string_literal: true

module Semver
  # Thrown when parsing a string that is not valid
  # [semver 2.0](https://semver.org/spec/v2.0.0.html).
  class InvalidFormatError < StandardError

    def initialize(value)
      msg = 'invalid format, expected semver string, e.g. ' \
        + '1.2.3, 1.2.3-rc.1, 1.2.3.alpha+1234567890, got :' \
        + value.inspect
      super(msg)
    end

  end
end
