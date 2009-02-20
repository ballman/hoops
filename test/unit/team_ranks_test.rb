require File.dirname(__FILE__) + '/../test_helper'

class TeamRanksTest < Test::Unit::TestCase
  fixtures :team_ranks

  # Replace this with your real tests.
  def test_truth
    assert_kind_of TeamRanks, team_ranks(:first)
  end
end
