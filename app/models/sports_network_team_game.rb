class SportsNetworkTeamGame < TeamGame
  def boxscore_name(player)
    player.sn_bs_name
  end

  def add_player_game!(player, name)
    player_games << SportsNetworkPlayerGame.new(:player => player, :player_name => name)
  end
end
