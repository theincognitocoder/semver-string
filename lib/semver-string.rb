class SemverString < String

  EMPTY_ERROR = 'must not be empty'

  INVALID_FORMAT = 'invalid format, expected semver string, e.g. ' +
    '1.2.3, 1.2.3-rc.1, 1.2.3.alpha+1234567890, got %s'

  SEMVER = /^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(-(0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(\.(0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*)?(\+[0-9a-zA-Z-]+(\.[0-9a-zA-Z-]+)*)?$/

  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] z
  # @param [String,nil] pre_release
  # @param [String,nil] build_metadata
  def initialize(x:, y:, z:, pre_release:nil, build_metadata:nil)
    @x = x
    @y = y
    @z = z
    @pre_release = pre_release ? pre_release[1..-1] : nil
    @build_metadata = build_metadata ? build_metadata[1..-1] : nil
    super("%d.%d.%d%s%s" % [x, y, z, pre_release, build_metadata])
  end

  # @return [Integer]
  attr_accessor :x

  # @return [Integer]
  attr_accessor :y

  # @return [Integer]
  attr_accessor :z

  # @return [String, nil]
  attr_accessor :pre_release

  # @return [String, nil]
  attr_accessor :build_metadata

  # See section #11 of https://semver.org/
  # @api private
  def <=>(other)

    # Precedence is determined by the first difference when comparing
    # each of these identifiers from left to right as follows:
    # Major, minor, and patch versions are always compared numerically.
    # Example: 1.0.0 < 2.0.0 < 2.1.0 < 2.1.1
    xyz_a = [x, y, z]
    xyz_b = [other.x, other.y, other.z]
    (0..2).each do |i|
      a = xyz_a[i].to_i
      b = xyz_b[i].to_i
      if a < b
        return -1
      elsif a > b
        return 1
      end
    end

    # When major, minor, and patch are equal, a pre-release version
    # has lower precedence than a normal version.
    # Example: 1.0.0-alpha < 1.0.0.
    pr_a = pre_release
    pr_b = other.pre_release
    if pr_a && !pr_b
      return -1
    elsif !pr_a && pr_b
      return 1
    elsif !pre_release && !other.pre_release
      return 0
    end

    # Precedence for two pre-release versions MUST be determined by
    # comparing each dot separated identifier from left to right until
    # a difference is found as follows:
    #
    # * identifiers consisting of only digits are compared numerically
    # * identifiers with letters or hyphens are compared lexically
    #   in ASCII sort order.
    # * Numeric identifiers always have lower precedence than
    #   non-numeric identifiers.
    # * A larger set of pre-release fields has a higher precedence
    #   than a smaller set, if all of the preceding identifiers are
    #   equal.
    #
    # Example: 1.0.0-alpha < 1.0.0-alpha.1 < 1.0.0-alpha.beta <
    #   1.0.0-beta < 1.0.0-beta.2 < 1.0.0-beta.11 < 1.0.0-rc.1 < 1.0.0
    pr_a = pr_a.split('.')
    pr_b = pr_b.split('.')
    [pr_a.size, pr_b.size].min.times do |i|
      a = pr_a[i]
      b = pr_b[i]

      # identifiers consisting of only digits are compared numerically
      if digits?(a, b)
        ai = a.to_i
        bi = b.to_i
        if ai < bi
          return -1
        elsif ai > bi
          return 1
        end
      end

      # identifiers with letters or hyphens are compared lexically
      # in ASCII sort order.
      if non_digits?(a, b)
        if a < b
          return -1
        elsif a > b
          return 1
        end
      end

      # Numeric identifiers have lower precedence than non-numeric
      # identifiers.
      if digits?(a) && non_digits?(b)
        return -1
      elsif non_digits?(a) && digits?(b)
        return 1
      end
    end

    # A larger set of pre-release fields has a higher precedence
    # than a smaller set, if all of the preceding identifiers are
    # equal.
    if pr_a.size < pr_b.size
      return -1
    elsif pr_a.size > pr_b.size
      return 1
    end

    return 0
  end

  private

  def digits?(*args)
    args.all? { |arg| arg.match(/^\d+$/) }
  end

  def non_digits?(*args)
    args.all? { |arg| arg.match(/^[a-zA-Z-]+$/) }
  end

  # @param [String] string
  # @return [Version]
  def self.new(string)
    raise InvalidFormatError.new(EMPTY_ERROR) if string.to_s.empty?
    matches = SEMVER.match(string)
    raise InvalidFormatError.new(INVALID_FORMAT % [string]) if !matches

    version = allocate
    version.send(:initialize,
      x: matches[1].to_i,
      y: matches[2].to_i,
      z: matches[3].to_i,
      pre_release: matches[4],
      build_metadata: matches[8],
    )
    version
  end

  class InvalidFormatError < StandardError; end

end
