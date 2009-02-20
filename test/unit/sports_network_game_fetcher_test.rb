require File.dirname(__FILE__) + '/../test_helper'

class SportsNetworkGameFetcherTest < Test::Unit::TestCase
  def setup
    @game_fetcher = SportsNetworkGameFetcher.new
  end

  def test_get_game_list_html
    html = @game_fetcher.get_game_list_html(Date.civil(2006, 11, 13),
                                            SportsNetworkGameFetcher::URL)
    assert_not_nil(html)
    assert(html.length > 50000)
  end

  def test_create_game_list
    games = @game_fetcher.create_game_list(File.new(File.dirname(__FILE__) +
    '/../fixtures/sports_network_scores.html').readlines.join)
    assert_equal(8, games.length)
    assert_equal("/merge/tsnform.aspx?c=sportsnetwork&amp;page=cbask/scores/final/boxscore.aspx?GAMEID=24906", games[0])
    assert_equal("/merge/tsnform.aspx?c=sportsnetwork&amp;page=cbask/scores/final/boxscore.aspx?GAMEID=23834", games[2])
    assert_equal("/merge/tsnform.aspx?c=sportsnetwork&amp;page=cbask/scores/final/boxscore.aspx?GAMEID=22799", games[7])
   end

  def test_get_game_source_id_good
    match = @game_fetcher.get_game_source_id("/merge/tsnform.aspx?c=sportsnetwork&amp;page=cbask/scores/final/boxscore.aspx?GAMEID=24906")
    assert_equal("24906", match)
   end

 def test_get_game_source_id_bad
  assert_nil(@game_fetcher.get_game_source_id("20060113_game_boxscore_manh.html"))
  end

  def test_loaded_game
    games = @game_fetcher.loaded_games(Date.civil(2005, 11, 11))
    assert_not_nil(games)
    assert_equal(1, games.length)
    assert_equal(games[0], '200511110017')
  end

   def test_get_games
     games = @game_fetcher.get_games(Date.civil(2006, 1, 13),
                                           SportsNetworkGameFetcher::URL)
     assert_equal(10, games.length)
     games[0].destroy
     games = @game_fetcher.get_games(Date.civil(2006, 1, 13), SportsNetworkGameFetcher::URL)
     assert_equal(1, games.length)
   end
end
