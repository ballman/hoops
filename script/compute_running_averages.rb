#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../config/boot'
require File.dirname(__FILE__) + '/../config/environment'

t = Team.find 23
games = t.games.select {|g| g.played_on > Date.new(2008,11,1) }



total_poss = total_ppp = other_total_ppp = 0   
game_count = 0
games.each do  |g|
   game_count += 1
   mine = g.master_team_games.detect { |mtg| mtg.team_id == t.id }
   other = g.master_team_games.detect { |mtg| mtg.team_id != t.id }

   other_poss = other.fga/1.0 - (other.offense_rebound/1.0 / (other.offense_rebound/1.0 + mine.total_rebound/1.0 - mine.offense_rebound/1.0) * 1.07 * (other.fga/1.0 - other.fgm/1.0)) + other.turnover/1.0 + 0.4 * other.fta 
   poss = mine.fga/1.0 - (mine.offense_rebound/1.0 / (mine.offense_rebound/1.0 + other.total_rebound/1.0 - other.offense_rebound/1.0) * 1.07 * (mine.fga/1.0 - mine.fgm/1.0)) + mine.turnover/1.0 + 0.4 * mine.fta 
      
ppp = mine.total_point / poss
   other_ppp = other.total_point / other_poss
   total_poss += poss
   total_ppp += ppp      
   other_total_ppp += other_ppp


   print "#{other_total_ppp/game_count}  ::::  #{g.played_on}  "
   puts "@ #{other.team.name}" if g.home_team_id != t.id
   puts "  #{other.team.name}" if g.home_team_id == t.id
end

