#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../config/boot'
require File.dirname(__FILE__) + '/../config/environment'

# total_poss = total_ppp = other_total_ppp = 0   
# game_count = 0
# games.each do  |g|
#    game_count += 1
#    mine = g.master_team_games.detect { |mtg| mtg.team_id == t.id }
#    other = g.master_team_games.detect { |mtg| mtg.team_id != t.id }

#    other_poss = other.fga/1.0 - (other.offense_rebound/1.0 / (other.offense_rebound/1.0 + mine.total_rebound/1.0 - mine.offense_rebound/1.0) * 1.07 * (other.fga/1.0 - other.fgm/1.0)) + other.turnover/1.0 + 0.4 * other.fta 
#    poss = mine.fga/1.0 - (mine.offense_rebound/1.0 / (mine.offense_rebound/1.0 + other.total_rebound/1.0 - other.offense_rebound/1.0) * 1.07 * (mine.fga/1.0 - mine.fgm/1.0)) + mine.turnover/1.0 + 0.4 * mine.fta 
      
# ppp = mine.total_point / poss
#    other_ppp = other.total_point / other_poss
#    total_poss += poss
#    total_ppp += ppp      
#    other_total_ppp += other_ppp


#    print "#{other_total_ppp/game_count}  ::::  #{g.played_on}  "
#    puts "@ #{other.team.name}" if g.home_team_id != t.id
#    puts "  #{other.team.name}" if g.home_team_id == t.id
# end


def add_averages(games, team, foe=false)
  sum_total_point =sum_fgm = sum_fga = sum_ftm = sum_fta = sum_tpm = sum_tpa = 0
  sum_offense_rebound = sum_total_rebound = sum_assist = sum_steal = 0
  sum_block = sum_turnover = sum_foul = sum_orp = sum_poss = sum_ppp = 0
  count = sum_total_point = 0
  
  average_klass = foe ? TeamFoeAverage : TeamAverage
  games.each do |game|
    count += 1
    mine = game.master_team_games.detect { |mtg| mtg.team_id == team.id }
    other = game.master_team_games.detect { |mtg| mtg.team_id != team.id }
    if (foe)
      mine, other =  other, mine
    end
    
    sum_total_point += mine.total_point
    sum_fgm += mine.fgm
    sum_fga += mine.fga
    sum_ftm += mine.ftm
    
    sum_fta += mine.fta
    sum_tpm += mine.tpm
    sum_tpa += mine.tpa
    sum_offense_rebound += mine.offense_rebound
    sum_total_rebound += mine.total_rebound
    sum_assist += mine.assist
    sum_steal += mine.steal
    sum_block += mine.block
    sum_turnover += mine.turnover
    sum_foul += mine.foul
    
    orp = mine.offense_rebound.to_f / (mine.offense_rebound.to_f + other.total_rebound.to_f - other.offense_rebound.to_f)
    sum_orp += orp
    
    poss = mine.fga.to_f - (orp * 1.07 * (mine.fga.to_f - mine.fgm.to_f)) + mine.turnover.to_f + 0.4 * mine.fta
    sum_poss += poss
    
      ppp = mine.total_point / poss
    sum_ppp += ppp
    
    average_klass.create(:team_id => team.id, :games => count,
                         :fgm => sum_fgm/count, :fga => sum_fga/count,
                         :fgp => sum_fgm.to_f/sum_fga.to_f,
                         :ftm => sum_ftm/count, :fta => sum_fta/count,
                         :ftp => sum_ftm.to_f/sum_fta.to_f,
                         :tpm => sum_tpm/count, :tpa => sum_tpa/count,
                         :tpp => sum_tpm.to_f/sum_tpa.to_f,
                         :eff_fgp => (sum_fgm + 0.5 * sum_tpm)/sum_fga,
                         :offense_rebound => sum_offense_rebound/count,
                         :total_rebound => sum_total_rebound/count,
                         :assist => sum_assist/count,
                         :steal  => sum_steal/count,
                         :block  => sum_block/count,
                         :turnover => sum_turnover/count,
                         :foul => sum_foul/count,
                         :half1_point => 0,
                         :half2_point => 0,
                         :total_point => sum_total_point/count,
                         :total_to => sum_turnover,
                         :ppp => sum_ppp/count,
                         :get_ft => sum_ftm/sum_fga,
                         :orp => sum_orp/count,
                         :to_rate => sum_turnover/sum_poss,
                         :poss => sum_poss/count,
                         :as_of => game.played_on)
  end
end

Team.all.each do |team|
  puts "#{team.name}"
  games = team.games.select {|g| g.played_on > Date.new(2008,11,1) }
  next if games.nil?
  add_averages(games, team)
  add_averages(games, team, true)
end

