class YahooTeamGame < TeamGame

  def boxscore_name(player)
    player.yahoo_bs_name
  end
  
  def add_player_game!(player, name)
    player_games << YahooPlayerGame.new(:player => player, :player_name => name)
  end

  def validate_player_total_for_stat(stat)
    player_total = player_games.inject(0) { | total, player | total + player.send(stat) }
    team_total = self.send(stat)
    if (player_total != team_total)
      "Team total of #{stat} does not sum.  Players = #{player_total}   Team = #{team_total}"
    end
  end
end
