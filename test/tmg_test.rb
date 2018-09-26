require "test_helper"
require 'tmg'

class TmgTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Tmg::VERSION
  end

  def test_sayhi
    assert Tmg.sayhi == 'hi'
  end
end
