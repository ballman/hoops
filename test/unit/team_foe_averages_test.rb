require File.dirname(__FILE__) + '/../test_helper'

class TeamFoeAveragesTest < Test::Unit::TestCase
  fixtures :team_foe_averages

  # Replace this with your real tests.
  def test_truth
    assert_kind_of TeamFoeAverages, team_foe_averages(:first)
  end
end
