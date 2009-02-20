require File.dirname(__FILE__) + '/../test_helper'

class PlayerGameTest < Test::Unit::TestCase
  fixtures :team, :player,  :games, :team_games, :player_games

  def test_validate_scoring_good
    player_game = PlayerGame.find(17)
    assert_nil(player_game.validate_scoring)
  end

  def test_validate_scoring_bad
    player_game = PlayerGame.find(5)
    assert_not_nil(player_game.validate_scoring)
  end

  def test_validate_ft_shooting_good
    player_game = PlayerGame.find(17)
    assert_nil(player_game.validate_ft_shooting)
  end    

  def test_validate_ft_shooting_bad
    player_game = PlayerGame.find(5)
    assert_not_nil(player_game.validate_ft_shooting)
  end    

  def test_validate_fg_shooting_good
    player_game = PlayerGame.find(17)
    assert_nil(player_game.validate_fg_shooting)
  end    

  def test_validate_fg_shooting_bad
    player_game = PlayerGame.find(5)
    assert_not_nil(player_game.validate_fg_shooting)
  end    

  def test_validate_tp_shooting_good
    player_game = PlayerGame.find(17)
    assert_nil(player_game.validate_tp_shooting)
  end    

  def test_validate_tp_shooting_bad
    player_game = PlayerGame.find(5)
    assert_not_nil(player_game.validate_tp_shooting)
  end    

  def test_validate_rebounds_good
    player_game = PlayerGame.find(17)
    assert_nil(player_game.validate_rebounds)
  end    

  def test_validate_rebounds_bad
    player_game = PlayerGame.find(5)
    assert_not_nil(player_game.validate_rebounds)
  end    

  def test_validate_foul_good
    player_game = PlayerGame.find(17)
    assert_nil(player_game.validate_foul)
  end    

  def test_validate_foul_bad
    player_game = PlayerGame.find(5)
    assert_not_nil(player_game.validate_foul)
  end    
end
