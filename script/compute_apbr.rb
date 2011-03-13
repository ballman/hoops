#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../config/boot'
require File.dirname(__FILE__) + '/../config/environment'

average_def_eff = TeamFoeAverage.average(:ppp)
puts "avereage_def_eff: #{average_def_eff}"
average_off_eff = TeamAverage.average(:ppp)
puts "avereage_off_eff: #{average_off_eff}"
games = Game.find(:all,
:include => :team_games,
:conditions => ['played_on > \'2010-11-1\' and team_games.type = \'MasterTeamGame\' and (home_team_id = 89 or away_team_id = 89)'])

total_ppp = games.inject(0.0) do | ppp, game |
  tg = game.team_games.collect { |tg| tg }
  if game.team_games[0].team_id != 89
    orp = 1.0 * tg[0].offense_rebound/(tg[0].offense_rebound + tg[1].total_rebound - tg[1].offense_rebound)
    poss_0 = tg[0].fga + tg[0].turnover + (0.4 * tg[0].fta) -  (orp * (tg[0].fga - tg[0].fgm) * 1.07)
    ppp_0 = tg[0].total_point / poss_0
    ppp_1 = 0.0
    poss_1 = 0.0
  else
    orp = 1.0  * tg[1].offense_rebound/(tg[1].offense_rebound + tg[0].total_rebound - tg[0].offense_rebound)
    poss_1 = tg[1].fga + tg[1].turnover + (0.4 * tg[1].fta) - (orp * (tg[1].fga - tg[1].fgm) * 1.07)
    ppp_1 = tg[1].total_point / poss_1
    ppp_0 = 0.0
    poss_0 = 0.0
  end
  ppp += poss_0 + poss_1
end

average_ppp = total_ppp / games.length
puts "average_ppp = #{average_ppp}"
puts "avereage_def_eff: #{average_def_eff}"
puts "avereage_off_eff: #{average_off_eff}"
puts "Number of games: #{games.length}"
#teams = Team.find(89).to_a
#teams.each do |team|
#  games = Game.find(:all,
#                     :include => :team_games,
#                     :conditions => ['played_on > \'2010-11-1\' and team_games.type = \'MasterTeamGame\' and (home_team_id = ? or visit_team_id = ?)', team.id, team.id])

#  games.each do |game|
#    my_game = (game.team_games[0].team_id == team.id) ? game.team_games[0] :
#                                                      game.team_games[1]
#    other_game = (game.team_games[0].team_id != team.id)?game.team_games[0] :
#                                                      game.team_games[1]
#    puts "#{my_game.team_name} vs. #{other_game.team_name}"
#  end
#end

