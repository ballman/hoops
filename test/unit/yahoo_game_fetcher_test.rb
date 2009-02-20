require File.dirname(__FILE__) + '/../test_helper'

class YahooGameFetcherTest < Test::Unit::TestCase
  def setup
    @yahoo_game_fetcher = YahooGameFetcher.new
  end

  def test_get_game_list_html
    html = @yahoo_game_fetcher.get_game_list_html(Date.civil(2006, 11, 13),
                                                 YahooGameFetcher::URL)
    assert_not_nil(html)
    assert(html.length > 50000)
  end

  def test_create_game_list
    games = @yahoo_game_fetcher.create_game_list(File.new(File.dirname(__FILE__) + '/../fixtures/yahoo_scoreboard.html').readlines.join)
    assert_equal(48, games.length)
    assert_equal("/ncaab/boxscore?gid=200611130016", games[0])
    assert_equal("/ncaab/boxscore?gid=200611130020", games[2])
    assert_equal("/ncaab/boxscore?gid=200611130630", games[47])
   end

  def test_get_game_source_id_good
    match = @yahoo_game_fetcher.get_game_source_id("/ncaab/boxscore?gid=200611130017")
    assert_equal("200611130017", match)
   end

  def test_get_game_source_id_bad
    assert_nil(@yahoo_game_fetcher.get_game_source_id("20060113_game_boxscore_manh.html"))
  end

  def test_loaded_game
    games = @yahoo_game_fetcher.loaded_games(Date.civil(2005, 11, 11))
    assert_not_nil(games)
    assert_equal(1, games.length)
    assert_equal(games[0], '200511110017')
  end

   def test_get_games
     games = @yahoo_game_fetcher.get_games(Date.civil(2006, 1, 13),
                                           YahooGameFetcher::URL)
     assert_equal(10, games.length)
     games[0].destroy
     games = @yahoo_game_fetcher.get_games(Date.civil(2006, 1, 13), CstvGameFetcher::URL)
     assert_equal(1, games.length)
   end
end
