require File.dirname(__FILE__) + '/../test_helper'

class CstvGameParserTest < Test::Unit::TestCase
  fixtures :conference, :team, :player, :games, :team_games, :player_games
  def setup
    @game_parser = CstvGameParser.new(File.new(File.dirname(__FILE__) + 
				      '/../fixtures/cstv_boxscore_parse_test.html').readlines.join,
				      Date.today)
  end

  def test_get_game_good
    game = @game_parser.get_game
    assert_not_nil(game)
    assert_equal(132, game.visit_team.id)
    assert_equal(90, game.home_team.id)
  end
    
  def test_get_game_bad
    game_parser = CstvGameParser.new(File.new(File.dirname(__FILE__) + 
					      '/../fixtures/cstv_boxscore.html').readlines.join,
				     Date.today)
    begin
      game = game_parser.get_game
      fail("should not reach this point without an error (exception)")
    rescue ArgumentError
      assert(true) # this is the expected behavior
    end
  end 
 
  def test_get_teams_good
    teams = @game_parser.get_teams
    assert_not_nil(teams)
    assert_equal(2, teams.length)
    assert_equal(132, teams[0].id)
    assert_equal(90, teams[1].id)
  end

  def test_get_teams_bad
    game_parser = CstvGameParser.new(File.new(File.dirname(__FILE__) + 
				      '/../fixtures/cstv_boxscore.html').readlines.join,
				      Date.today)
    teams = game_parser.get_teams
    assert_not_nil(teams)
    assert_equal(2, teams.length)
    assert_nil(teams[0])
    assert_nil(teams[1])
  end    


  def test_get_team_from_score_line_good
    team = @game_parser.get_team_from_score_line("CLEVELAND ST        13  23 - 35")
    assert_not_nil(team)
    assert_equal(132, team.id)
  end

  def test_get_team_from_score_line_bad
    team = @game_parser.get_team_from_score_line("NOT THERE         12 12 - 24")
    assert_nil(team)

    team = @game_parser.get_team_from_score_line("bad score line")
    assert_nil(team)
  end

  def test_get_scores_from_score_line
    scores = @game_parser.get_scores_from_score_line("NOT THERE         12 22 - 34  \n")
    assert_not_nil(scores)
    assert_equal(7, scores.length) 
    assert_equal(12, scores[0])
    assert_equal(22, scores[1])
    assert_equal(0, scores[2])
    assert_equal(0, scores[3])
    assert_equal(0, scores[4])
    assert_equal(0, scores[5])
    assert_equal(34, scores[6])

    scores = @game_parser.get_scores_from_score_line("NOT THERE         11 23 13 14 15 16 - 92 \n")
    assert_not_nil(scores)
    assert_equal(7, scores.length) 
    assert_equal(11, scores[0])
    assert_equal(23, scores[1])
    assert_equal(13, scores[2])
    assert_equal(14, scores[3])
    assert_equal(15, scores[4])
    assert_equal(16, scores[5])
    assert_equal(92, scores[6])
    
 end

  def test_get_stats_from_line
    stats = @game_parser.get_stats_from_line("G. Player, G   200   4-5  6-7  8-10 11 12 13 14  ")
    assert_not_nil(stats)
    assert_equal(11, stats.length)
    assert_equal(200, stats[0])
    assert_equal(4, stats[1])
    assert_equal(5, stats[2])
    assert_equal(6, stats[3])
    assert_equal(7, stats[4])
    assert_equal(8, stats[5])
    assert_equal(10, stats[6])
    assert_equal(11, stats[7])
    assert_equal(12, stats[8])
    assert_equal(13, stats[9])
    assert_equal(14, stats[10])
  end

  def test_get_turnovers
    turnovers = @game_parser.get_turnovers(0)

    assert_not_nil(turnovers)
    assert_equal(9, turnovers.length)
    assert_equal(16, turnovers['TOTAL'])
    assert_equal(3, turnovers['F McGee'])
    assert_equal(1, turnovers['V Morris'])
  end

  def test_get_blocks
    blocks = @game_parser.get_blocks(0)
    assert_not_nil(blocks)
    assert_equal(2, blocks.length)
    assert_equal(1, blocks['TOTAL'])
    assert_equal(1, blocks['J Bullock'])
  end

  def test_get_steals
    steals = @game_parser.get_steals(0)
    assert_not_nil(steals)
    assert_equal(7, steals.length)
    assert_equal(9, steals['TOTAL'])
    assert_equal(2, steals['J Bullock'])
    assert_equal(1, steals['P Tatham'])
  end

  def test_get_tpm
    tpm = @game_parser.get_tpm(0)
    assert_not_nil(tpm)
    assert_equal(9, tpm.length)
    assert_equal(14, tpm['TOTAL'])
    assert_equal(4, tpm['R Moss'])
    assert_equal(0, tpm['F McGee'])
  end

  def test_get_tpa
    tpa = @game_parser.get_tpa(0)
    assert_equal(9, tpa.length)
    assert_equal(31, tpa['TOTAL'])
    assert_equal(8, tpa['R Moss'])
    assert_equal(2, tpa['L Murphy'])
  end

  def test_get_team_rebounds
    assert_equal(2, @game_parser.get_team_rebounds(0))
    assert_equal(5, @game_parser.get_team_rebounds(1))
  end

  def test_get_box_extras
    assert_not_nil(@game_parser.get_box_extras)
  end

  def test_build_team_game
    team_game = @game_parser.build_team_game(0, Team.find(132))
    assert_not_nil(team_game)
    assert_equal(11, team_game.player_games.length)
  end

  def test_get_player_games
    assert_not_nil(@game_parser.get_player_games(1))
  end

  def test_parse
    game = @game_parser.parse
    game.save

    assert_equal(game.home_team, Team.find(90))
    assert_equal(game.visit_team, Team.find(132))
    assert_equal(game.played_on, Date.today)
    
    assert_not_nil(game.visit_team_game)
    assert_not_nil(game.home_team_game)
    assert_equal(0, game.home_team_game.different_stats(TeamGame.find(5)).length, 
		 "Home: " + game.home_team_game.different_stats(TeamGame.find(5)).join("\n   "))
    assert_equal(0, game.visit_team_game.different_stats(TeamGame.find(6)).length, 
		 "Visit: " + game.visit_team_game.different_stats(TeamGame.find(6)).join("\n   "))

    assert_equal(11, game.visit_team_game.player_games.length)
    diff = game.visit_team_game.player_games[1].different_stats(PlayerGame.find(12))
    diff.each { |d| puts d }
    assert_equal(0, diff.length, "  " + diff.join("\n  "))
    diff = game.visit_team_game.player_games[3].different_stats(PlayerGame.find(13))
    assert_equal(0, diff.length, "  " + diff.join("\n  "))

    assert_equal(10, game.home_team_game.player_games.length)
    diff = game.home_team_game.player_games[0].different_stats(PlayerGame.find(10))
    assert_equal(0, diff.length, "  " + diff.join("\n  "))
    diff = game.home_team_game.player_games[3].different_stats(PlayerGame.find(11))
    assert_equal(0, diff.length, "  " + diff.join("\n  "))
  end
end

