require File.dirname(__FILE__) + '/../test_helper'

class FoxGameFetcherTest < Test::Unit::TestCase
  fixtures :game_files
  def setup
    @fox_game_fetcher = FoxGameFetcher.new
  end

   def test_get_game_list_html
     html = @fox_game_fetcher.get_game_list_html(Date.civil(2006, 1, 13), FoxGameFetcher::URL)
     assert_not_nil(html)
     assert(html.length > 50000)
   end

   def test_create_game_list
     games = @fox_game_fetcher.create_game_list(File.new(File.dirname(__FILE__) + 
                                                 '/../fixtures/fox_scores.html').readlines.join)
     assert_equal(10, games.length)
     assert_equal("/cbk/boxscore?gameId=200601130155", games[0])
     assert_equal("/cbk/boxscore?gameId=200601130088", games[3])
     assert_equal("/cbk/boxscore?gameId=200601130311", games[9])
   end
  
  def test_get_games
    games = @fox_game_fetcher.get_games(Date.civil(2006, 1, 13), FoxGameFetcher::URL)
    assert_equal(10, games.length)
    games[0].destroy
    games = @fox_game_fetcher.get_games(Date.civil(2006, 1, 13), FoxGameFetcher::URL)
    assert_equal(1, games.length)
  end
end
