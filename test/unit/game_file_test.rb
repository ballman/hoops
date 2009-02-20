require File.dirname(__FILE__) + '/../test_helper'

class GameFileTest < Test::Unit::TestCase
  fixtures :game_files

  def setup
    @game_file = GameFile.find(1)
  end
  
  # Replace this with your real tests.
  def test_truth
    assert_kind_of GameFile, @game_file
  end
end
