$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'simplecov'
SimpleCov.start
require "tmg"

require 'coveralls'
require 'simplecov-console'
require "minitest/autorun"
require 'minitest/reporters'
Coveralls.wear!
SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::Console,
])
Minitest::Reporters.use!
