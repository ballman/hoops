require File.dirname(__FILE__) + '/../test_helper'

class ConferenceTest < Test::Unit::TestCase
  fixtures :conference, :team, :player,  :games, :team_games, :player_games

  def setup
    @conference = Conference.find(1)
  end

  # ------------------------------------------------------------ test
  def test_truth
    assert_kind_of Conference,  @conference
    assert @conference.teams
    assert_equal 1, @conference.teams.size
    assert_kind_of Team, @conference.teams[0]
  end
end
