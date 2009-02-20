require File.dirname(__FILE__) + '/../test_helper'

class TeamAveragesTest < Test::Unit::TestCase
  fixtures :team_averages

  # Replace this with your real tests.
  def test_truth
    assert_kind_of TeamAverages, team_averages(:first)
  end
end
