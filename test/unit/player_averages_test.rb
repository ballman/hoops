require File.dirname(__FILE__) + '/../test_helper'

class PlayerAveragesTest < Test::Unit::TestCase
  fixtures :player_averages

  # Replace this with your real tests.
  def test_truth
    assert_kind_of PlayerAverages, player_averages(:first)
  end
end
