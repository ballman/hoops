#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../config/boot'
require File.dirname(__FILE__) + '/../config/environment'

games = Game.find(:all, :conditions => ['id > ?',4731])



games.each do | game |
  if (!game.has_file_for_type?(CstvGameFile) && game.has_file_for_type?(FoxGameFile))
    puts game.id
    [game.home_team_game_for_type(CstvTeamGame), game.visit_team_game_for_type(CstvTeamGame)].each do | cstv_game |
      new_team_game = FoxTeamGame.new(cstv_game.attributes)
      new_team_game.player_games = cstv_game.player_games.collect { | player_game | FoxPlayerGame.new(player_game.attributes) }
      new_team_game.save
    end
  end
end


