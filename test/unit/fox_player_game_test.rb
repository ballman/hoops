require File.dirname(__FILE__) + '/../test_helper'

class FoxPlayerGameTest < Test::Unit::TestCase
  fixtures :team, :player,  :games, :team_games, :player_games

  def test_validate_correct_player_bad_first_name
    player_game = FoxPlayerGame.find(5)
    assert_not_nil(player_game.validate_correct_player)
  end

  def test_validate_correct_player_bad_last_name
    player_game = FoxPlayerGame.find(5)
    player_game.player_name = 'J Jonson, G'
    assert_not_nil(player_game.validate_correct_player)
  end

  def test_validate_correct_player_good
    player_game = FoxPlayerGame.find(1)
    assert_nil(player_game.validate_correct_player)
  end
end
