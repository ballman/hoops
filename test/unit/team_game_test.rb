require File.dirname(__FILE__) + '/../test_helper'

class TeamGameTest < Test::Unit::TestCase
  fixtures :team, :player,  :games, :team_games, :player_games

  def setup 
    @team_game = TeamGame.find(1)
  end

  def test_validate_score_breakdown
    assert_nil(@team_game.validate_score_breakdown)

    @team_game.half1_point = 0
    assert_not_nil(@team_game.validate_score_breakdown)
  end
  
  def test_validate_score_by_mades
    assert_nil(@team_game.validate_score_by_mades)

    @team_game.fgm -= 1
    assert_not_nil(@team_game.validate_score_by_mades)
  end

  def test_validate_player_totals_good
    team_game = TeamGame.find(3)
    valid_errors = team_game.validate_player_totals
    assert_not_nil(valid_errors)
    assert_equal(0, valid_errors.length)
  end

  def test_validate_player_totals_bad
    team_game = TeamGame.find(1) 
    valid_errors = team_game.validate_player_totals
    assert_not_nil(valid_errors)
    assert_equal(13, valid_errors.length)
  end

  def test_validate_unique_players_bad
    team_game = TeamGame.find(4)
    valid_errors = team_game.validate_unique_players
    assert_not_nil(valid_errors)
    assert_equal(1, valid_errors.length)
  end

  def test_validate_unique_players_good
    team_game = TeamGame.find(1)
    valid_errors = team_game.validate_unique_players
    assert_not_nil(valid_errors)
    assert_equal(0, valid_errors.length)
  end
end
