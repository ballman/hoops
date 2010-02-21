class FoxTeamGame < TeamGame

  def boxscore_name(player)
    player.fox_bs_name
  end

  def add_player_game!(player, name)
    player_games << FoxPlayerGame.new(:player => player, :player_name => name)
  end
end
