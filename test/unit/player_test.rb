require File.dirname(__FILE__) + '/../test_helper'

class PlayerTest < Test::Unit::TestCase
  fixtures :team, :player,  :games, :team_games, :player_games

  def setup
    @player = Player.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Player,  @player
  end

  def test_last_name_closeness
    assert_equal(1.0, @player.last_name_closeness(@player.last_name))
    assert_not_equal(@player.last_name.length - 1/@player.last_name.length, 
		     @player.last_name_closeness(@player.last_name.slice(0, 
                 						@player.last_name.length - 1)))

  end

  def test_first_name_closeness
    assert_equal(1.0, @player.first_name_closeness(@player.first_name))
    assert_not_equal(@player.first_name.length - 1/@player.first_name.length, 
		     @player.first_name_closeness(@player.first_name.slice(0, 
						                  @player.first_name.length - 1)))

  end
end
