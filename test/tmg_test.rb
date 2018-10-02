require "test_helper"
require 'tmg'
require 'yaml'
require 'dotenv'
require 'tempfile'

Dotenv.load

class TmgTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Tmg::VERSION
  end

  def test_write_credentials_denied
    assert_raises RuntimeError do
      Tmg.write_credentials('123', '456', '.')
    end
  end

  def test_write_credentials_successfuly
    username = ENV['username']
    password = ENV['password']
    tempfile = Tempfile.new('credentials', '.')
    temp_filename = File.basename(tempfile.path)
    assert Tmg.write_credentials(username, password, '.', temp_filename)
    api_key = YAML.load_file(tempfile)
    refute_nil api_key[:rubygems_api_key]
  end
end
