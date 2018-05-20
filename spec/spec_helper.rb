# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

require 'simplecov'
require 'coveralls'

reporters = [
  Coveralls::SimpleCov::Formatter,
  SimpleCov::Formatter::HTMLFormatter,
].compact

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(reporters)
SimpleCov.start

require 'semver-string'
