class CstvGame < Game
  def home_team_game
    cstv_team_game(game.home_team)
  end
  
  def away_team_game
    cstv_team_game(game.away_team)
  end

  private
  def cstv_team_game(team)
    team_games.detect { |team_game| ((team_game.team == team) && (team_game.is_a?(CstvTeamGame))) }
  end
end  
