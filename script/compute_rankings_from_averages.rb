#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../config/boot'
require File.dirname(__FILE__) + '/../config/environment'

# column information
cols = %w(fgm fga fgp tpm tpa tpp ftm fta ftp offense_rebound total_rebound
          assist steal block turnover foul half1_point half2_point total_point
	  ppp eff_fgp to_rate orp get_ft poss)
reverse = %w(turnover to_rate foul).inject({}) {|h,w| h[w] = true; h }

puts "Reading team list..."
teams = Team.find(:all).inject({}) {|h,t| h[t.id] = t; h }

# collect rankings
[false, true].each do |foe|
  puts "Computing #{foe ? 'foe' : 'normal'} rankings..."
  puts "Reading team statistics..."

  ave = (foe ? Team.all.collect(&:opp_stats) : Team.all.collect(&:stats)).compact
  puts "Initializing rankings store..."
  grid = teams.keys.inject({}) {|h,t| h[t] = {}; h } # grid of ranks, by team_id

  cols.each do |col|
    puts "Processing statistic [#{col}]..."
    ave.sort_by do |s| 
      s.send(col) * (reverse[col] ? 1.0 : -1.0) * (foe ? -1.0 : 1.0)
    end.each_with_index do |row, i| 
  #     puts "#{teams[row.team_id].name} is ##{i+1} in #{col} with [#{row.send(col)}]"
      grid[row.team_id][col] = i+1
    end
  end
  
  (foe ? TeamFoeRanks : TeamRanks).destroy_all
  
  # save rankings
  grid.keys.each do |team_id|
    puts "Saving [#{teams[team_id].name}]..."
    rank = (foe ? TeamFoeRanks : TeamRanks).new
    rank.team_id = team_id
    cols.each do |col|
      rank.send("#{col}=", grid[team_id][col])
    end
    rank.save
  end
end
