require File.dirname(__FILE__) + '/../test_helper'

class FoxGameFetcherTest < Test::Unit::TestCase
  fixtures :game_files
  def setup
    @cstv_game_fetcher = CstvGameFetcher.new
  end

  def test_get_game_list_html
    html = @cstv_game_fetcher.get_game_list_html(Date.civil(2006, 1, 13),
						 CstvGameFetcher::URL)
    assert_not_nil(html)
    assert(html.length > 50000)
  end
  
  def test_create_game_list
    games = @cstv_game_fetcher.create_game_list(File.new(File.dirname(__FILE__) + '/../fixtures/cstv_scores.html').readlines.join)
    assert_equal(10, games.length)
    assert_equal("/teams/m-baskbl/scoreboards/ivy/20060113_game_boxscore_dart.html", games[0])
    assert_equal("/teams/m-baskbl/scoreboards/maac/20060113_game_boxscore_manh.html", games[2])
    assert_equal("/teams/m-baskbl/scoreboards/bigw/20060113_game_boxscore_lbst.html", games[9])
  end
  
  def test_get_game_source_id_good
    match = @cstv_game_fetcher.get_game_source_id("/ds/maac/20060113_game_boxscore_manh.html")
    assert_equal("maac_20060113_manh", match)
  end     

  def test_get_game_source_id_bad
    assert_nil(@cstv_game_fetcher.get_game_source_id("20060113_game_boxscore_manh.html"))
  end
  
  def test_loaded_game
    games = @cstv_game_fetcher.loaded_games(Date.civil(2005, 11, 11))
    assert_not_nil(games)
    assert_equal(games.length, 1)
    assert_equal(games[0], 'ivy_20051111_harv')
  end
  
  def test_get_games
    games = @cstv_game_fetcher.get_games(Date.civil(2006, 1, 13), CstvGameFetcher::URL)
    assert_equal(10, games.length)
    games[0].destroy
    games = @cstv_game_fetcher.get_games(Date.civil(2006, 1, 13), CstvGameFetcher::URL)
    assert_equal(1, games.length)
  end
end
