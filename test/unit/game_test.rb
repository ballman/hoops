require File.dirname(__FILE__) + '/../test_helper'

class GameTest < Test::Unit::TestCase
  fixtures :team, :player,  :games, :team_games, :player_games

  def test_find_or_create_does_not_exist
    # only the date is wrong
    game = Game.find_or_create(Date.civil(2006,1,20), Team.find(132), Team.find(90))
    assert_kind_of Game, game
    assert(game.new_record?)

    # only the visiting team is wrong
    game = Game.find_or_create(Date.civil(2005,1,1), Team.find(90), Team.find(90))
    assert_kind_of Game, game
    assert(game.new_record?)

    # only the home team is wrong
    game = Game.find_or_create(Date.civil(2005,1,1), Team.find(132), Team.find(132))
    assert_kind_of Game, game
    assert(game.new_record?)
  end

  def test_find_or_create_exists
    game = Game.find_or_create(Date.civil(2005,1,1), Team.find(132), Team.find(90))
    assert_kind_of Game, game
    assert(!game.new_record?)
  end

end
