require File.dirname(__FILE__) + '/../test_helper'
require 'rubygems'

class GameParserTest < Test::Unit::TestCase
  def setup
    @game_parser = SportsNetworkGameParser.new("<html></html>", Date.today)
    @game_file = File.new(File.dirname(__FILE__) +
                          '/../fixtures/sports_network_boxscore.html').readlines.join
    @good_game_parser = SportsNetworkGameParser.new(@game_file, Date.today)
  end

  def test_get_teams
    teams_array = @good_game_parser.get_teams
    assert_not_nil(teams_array)
    assert_equal(2, teams_array.length)
    assert_not_nil(teams_array[0])
    assert_equal(2, teams_array[0].length)
    assert_equal(2, teams_array[1].length)
    assert_equal('Cleveland State', teams_array[0][0])
    assert_equal(132, teams_array[0][1].id)
    assert_equal('Michigan State', teams_array[1][0])
    assert_equal(90, teams_array[1][1].id)
  end

  def test_home_final_score
    assert_equal(83, @good_game_parser.home_final_score)
  end

  def test_visit_final_score
    assert_equal(75, @good_game_parser.visit_final_score)
  end

  def test_visit_scores_by_period
    scores  = @good_game_parser.visit_scores_by_period
    assert_not_nil(scores)
    assert_equal([46, 29], scores)
  end

  def test_home_scores_by_period
    scores  = @good_game_parser.home_scores_by_period
    assert_not_nil(scores)
    assert_equal([40, 43], scores)
  end

  def test_visit_total_line
    totals = @good_game_parser.visit_total_line
    assert_not_nil(totals)
    assert_equal([200,26,64,14,31,9,13,8,21,29,22,27,9,16,1,75],
                 totals)
  end

  def test_home_total_line
    totals = @good_game_parser.home_total_line
    assert_not_nil(totals)
    assert_equal([200,28,53,5,13,22,29,9,33,42,18,17,10,19,4,83], totals)
  end

  def test_visit_team_rebound
    assert_equal(2, @good_game_parser.visit_team_rebound)
  end

  def test_home_team_rebound
    assert_equal(5, @good_game_parser.home_team_rebound)
  end

  def test_visit_team_turnover
    assert_equal(0, @good_game_parser.visit_team_turnover)
  end

  def test_home_team_turnover
    assert_equal(0, @good_game_parser.home_team_turnover)
  end

  def test_home_team_game
    home_team_game = @good_game_parser.home_team_game(Team.find(90))
    assert_not_nil(home_team_game)
    home_team_game.team_name = 'Michigan State'
    assert_equal(0, home_team_game.different_stats(TeamGame.find(5)).length,
                 "Home: " + home_team_game.different_stats(TeamGame.find(5)).join("\n   "))
  end

  def test_visit_team_game
    visit_team_game = @good_game_parser.visit_team_game(Team.find(132))
    assert_not_nil(visit_team_game)
    visit_team_game.team_name = 'Cleveland State'
    assert_equal(0, visit_team_game.different_stats(TeamGame.find(6)).length,
                 "Visit: " + visit_team_game.different_stats(TeamGame.find(6)).join("\n   "))
  end

  def test_good_parse
    game = @good_game_parser.parse
    game.save
    assert_equal(game.home_team, Team.find(90))
    assert_equal(game.visit_team, Team.find(132))
    assert_equal(game.played_on, Date.today)

    assert_not_nil(game.visit_team_game)
    assert_not_nil(game.home_team_game)
    assert_equal(0, game.home_team_game.different_stats(TeamGame.find(5)).length, "Home: " + game.home_team_game.different_stats(TeamGame.find(5)).join("\n   "))
    assert_equal(0, game.visit_team_game.different_stats(TeamGame.find(6)).length, "Visit: " + game.visit_team_game.different_stats(TeamGame.find(6)).join("\n   "))
    assert_equal(11, game.visit_team_game.player_games.length)
    diff = game.visit_team_game.player_games[1].different_stats(PlayerGame.find(11))
    assert_equal(0, diff.length, "  " + diff.join("\n  "))
    diff = game.visit_team_game.player_games[3].different_stats(PlayerGame.find(12))
    assert_equal(0, diff.length, "  " + diff.join("\n  "))

    assert_equal(10, game.home_team_game.player_games.length)
    diff = game.home_team_game.player_games[0].different_stats(PlayerGame.find(9))
    assert_equal(0, diff.length, "  " + diff.join("\n  "))
    diff = game.home_team_game.player_games[3].different_stats(PlayerGame.find(10))
    assert_equal(0, diff.length, "  " + diff.join("\n  "))
  end

#   def test_bad_parse
#     begin
#       @game_parser = GameParser.new("<html></html>", Date.today)
#       @game_parser.parse
#       flunk("Should have thrown a bad argument error.")
#     rescue ArgumentError
#       # this is expected
#     end

#   end
end
