#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../config/boot'
require File.dirname(__FILE__) + '/../config/environment'

# column information
cols = %w(fgm fga fgp tpm tpa tpp ftm fta ftp offense_rebound total_rebound
          assist steal block turnover foul half1_point half2_point total_point
	  ppp eff_fgp to_rate orp get_ft poss)
reverse = %w(turnover to_rate foul).inject({}) {|h,w| h[w] = true; h }

puts "Reading team list..."
@teams = Team.find(:all).inject({}) {|h,t| h[t.id] = t; h}

puts "Reading team statistics..."
@team_stats = TeamAverage.find(:all).sort_by {|t| @teams[t.id].name }
@foe_stats = TeamFoeAverage.find(:all).sort_by {|t| @teams[t.id].name }.inject({}) {|h,s| h[s.id] = s; h}

puts "Initializing rankings store..."
grid = @teams.keys.inject({}) {|h,t| h[t] = {}; h } # grid of ranks, by team_id

cols.each do |col|
  puts "Processing statistic [#{col}]..."
  @team_stats.sort_by do |s| 
    (s.send(col)-@foe_stats[s.team_id].send(col)) * (reverse[col] ? 1.0 : -1.0) 
  end.each_with_index do |row, i| 
    puts "#{@teams[row.team_id].name} is ##{i+1} in #{col} with [#{row.send(col)-@foe_stats[row.team_id].send(col)}]"
    grid[row.team_id][col] = i+1
  end
end

TeamDiffRanks.destroy_all

# save rankings
grid.keys.each do |team_id|
  puts "Saving [#{@teams[team_id].name}]..."
  rank = TeamDiffRanks.new
  rank.team_id = team_id
  cols.each do |col|
    rank.send("#{col}=", grid[team_id][col])
  end
  rank.save
end
