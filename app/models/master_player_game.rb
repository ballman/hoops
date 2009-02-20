class MasterPlayerGame < PlayerGame
  def boxscore_name
    return $1 if player_name =~ /(.*), [FCGfcg]$/
    return player_name
  end
end
