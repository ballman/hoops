require File.dirname(__FILE__) + '/../test_helper'
require 'rubygems'

class GameParserTest < Test::Unit::TestCase
  def setup
    @game_parser = YahooGameParser.new("<html></html>", Date.today)
    @game_file = File.new(File.dirname(__FILE__) +
                          '/../fixtures/yahoo_boxscore.html').readlines.join
    @good_game_parser = YahooGameParser.new(@game_file, Date.today)
  end

  def test_team_from_link
    link = "http://sports.yahoo.com/ncaab/teams/may"
    team = @game_parser.team_from_link(link)
    assert_not_nil(team)
    assert_equal(90, team.id)
  end

  def test_no_team_from_link
    link = "http://sports.yahoo.com/ncaab/teams/xxx"
    team = @game_parser.team_from_link(link)
    assert_nil(team)
  end

  def test_get_teams
    teams_array = @good_game_parser.get_teams
    assert_not_nil(teams_array)
    assert_equal(2, teams_array.length)
    assert_not_nil(teams_array[0])
    assert_equal(2, teams_array[0].length)
    assert_equal(2, teams_array[1].length)
    assert_equal('Cleveland St.', teams_array[0][0])
    assert_equal(132, teams_array[0][1].id)
    assert_equal('Michigan St.', teams_array[1][0])
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
    assert_equal(['', '200','26-64','14-31','9-13','8','27','22','16','9','1','27','75'], totals)
  end

  def test_home_total_line
    totals = @good_game_parser.home_total_line
    assert_not_nil(totals)
    assert_equal(['', '200','28-53','5-13','22-29','8','37','18','19','10','4','17','83'], totals)
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
    home_team_game.team_name = 'Michigan St.'
    assert_equal(0, home_team_game.different_stats(TeamGame.find(3)).length,
                 "Home: " + home_team_game.different_stats(TeamGame.find(3)).join("\n   "))
  end

  def test_visit_team_game
    visit_team_game = @good_game_parser.visit_team_game(Team.find(132))
    assert_not_nil(visit_team_game)
    visit_team_game.team_name = 'Cleveland St.'
    assert_equal(0, visit_team_game.different_stats(TeamGame.find(4)).length,
                 "Visit: " + visit_team_game.different_stats(TeamGame.find(4)).join("\n   "))
  end

 def test_good_parse
   game = @good_game_parser.parse
   game.save
   assert_equal(game.home_team, Team.find(90))
   assert_equal(game.visit_team, Team.find(132))
   assert_equal(game.played_on, Date.today)

   assert_not_nil(game.visit_team_game)
   assert_not_nil(game.home_team_game)
   assert_equal(0, game.home_team_game.different_stats(TeamGame.find(3)).length, "Home: " + game.home_team_game.different_stats(TeamGame.find(3)).join("\n   "))
   assert_equal(0, game.visit_team_game.different_stats(TeamGame.find(4)).length, "Visit: " + game.visit_team_game.different_stats(TeamGame.find(4)).join("\n   "))

   assert_equal(11, game.visit_team_game.player_games.length)
   diff = game.visit_team_game.player_games[1].different_stats(PlayerGame.find(7))
   assert_equal(0, diff.length, "  " + diff.join("\n  "))
   diff = game.visit_team_game.player_games[3].different_stats(PlayerGame.find(8))
   assert_equal(0, diff.length, "  " + diff.join("\n  "))

   assert_equal(10, game.home_team_game.player_games.length)
   diff = game.home_team_game.player_games[0].different_stats(PlayerGame.find(5))
   assert_equal(0, diff.length, "  " + diff.join("\n  "))
   diff = game.home_team_game.player_games[3].different_stats(PlayerGame.find(6))
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
