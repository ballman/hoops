require File.dirname(__FILE__) + '/../test_helper'

class TeamFoeRanksTest < Test::Unit::TestCase
  fixtures :team_foe_ranks

  # Replace this with your real tests.
  def test_truth
    assert_kind_of TeamFoeRanks, team_foe_ranks(:first)
  end
end
