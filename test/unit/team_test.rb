require File.dirname(__FILE__) + '/../test_helper'

class TeamTest < Test::Unit::TestCase
  fixtures :team, :player,  :games, :team_games, :player_games

  def setup
    @team = Team.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Team,  @team
  end
end
