#!/usr/bin/ruby
require 'hpricot'

class SportsNetworkGameParser
  def initialize(_raw_html, played_on)
    @doc = Hpricot(_raw_html)
    @played_on = played_on
  end

  def parse
    teams = get_teams

    @game = Game.find_or_create(@played_on, teams[0][1], teams[1][1])
    @game.visit_team_game = visit_team_game(@game.visit_team)
    @game.home_team_game = home_team_game(@game.home_team)
    @game.visit_team_game.team_name = teams[0][0]
    @game.home_team_game.team_name = teams[1][0]

    @game.visit_team_game.player_games = build_player_games(0)
    @game.home_team_game.player_games = build_player_games(1)


    @game.visit_team_game.map_player_games
    @game.home_team_game.map_player_games
    @game
  end

  def get_teams
    score_lines.map do | line |
      team = Team.find(:first, :conditions => [ "sn_code = ?", line[0] ])
      raise ArgumentError, "Unable to find team: #{line[0]}" if (team.nil?)
      [line[0], team]
    end
  end

  def home_scores_by_period
    scores_by_period(1)
  end

  def home_final_score
    final_score(1)
  end

  def home_total_line
    team_total_lines(1)
  end

  def home_team_rebound
    team_rebounds(1)
  end

  def home_team_turnover
    team_turnovers(1)
  end

  def home_team_game(team)
    new_team_game(team, home_total_line,
                  home_scores_by_period, home_final_score,
                  home_team_turnover, home_team_rebound)
  end

  def visit_scores_by_period
    scores_by_period(0)
  end

  def visit_final_score
    final_score(0)
  end

  def visit_total_line
    team_total_lines(0)
  end

  def visit_team_rebound
    team_rebounds(0)
  end

  def visit_team_turnover
    team_turnovers(0)
  end

  def visit_team_game(team)
    new_team_game(team, visit_total_line,
                  visit_scores_by_period, visit_final_score,
                  visit_team_turnover, visit_team_rebound)
  end

  def new_team_game(team, team_line, scores, total_score, team_turnover, team_rebound)
    team_game = SportsNetworkTeamGame.new
    team_game.team = team

    (team_game.half1_point, team_game.half2_point, team_game.ot1_point,
     team_game.ot2_point, team_game.ot3_point, team_game.ot4_point,
     team_game.ot5_point) = scores.fill(0, scores.length .. 6)
    team_game.total_point = total_score

    team_game.minutes = team_line[0]
    team_game.fgm = team_line[1]
    team_game.fga = team_line[2]
    team_game.tpm = team_line[3]
    team_game.tpa = team_line[4]
    team_game.ftm = team_line[5]
    team_game.fta = team_line[6]
    team_game.offense_rebound = team_line[7]
    team_game.total_rebound = team_line[9]
    team_game.assist = team_line[10]
    team_game.foul = team_line[11]
    team_game.steal = team_line[12]
    team_game.turnover = team_line[13]
    team_game.block = team_line[14]
    team_game.team_turnover = team_turnover
    team_game.team_rebound = team_rebound
    team_game
  end

  def get_team_turnovers(data, position)
    return get_team_extras(data, 'Team Turnovers:', position)
  end

  def get_team_rebounds(data, position)
    return get_team_extras(data, 'Team Rebounds:', position)
  end

  def get_team_scores(data_table)
    scores = Array.new
    data_table.each do | table |
      table.elements.each('*/tr[@class="sbTeam"]/td | tr[@class="sbTeam"]/td') do |td|
        scores << td.text unless td.has_attributes? || td.has_elements?
        td.elements.each('div[@class="scoreboxTotal"]') do |final|
          scores << final.text
        end
      end
    end
    return scores
  end

  def build_player_games(team_index)
    stats = player_stats(team_index)
    stats.reject {|p| (p[0].strip == 'TEAM')}.collect do | stats |
      new_player_game(stats)
    end
  end


  def new_player_game(player_line)
    player_game = SportsNetworkPlayerGame.new
    player_game.player_name = player_line[0]
    player_game.minutes = player_line[1]
    player_game.fgm = player_line[2]
    player_game.fga = player_line[3]
    player_game.tpm = player_line[4]
    player_game.tpa = player_line[5]
    player_game.ftm = player_line[6]
    player_game.fta = player_line[7]
    player_game.offense_rebound = player_line[8]
    player_game.total_rebound = player_line[10]
    player_game.assist = player_line[11]
    player_game.foul = player_line[12]
    player_game.steal = player_line[13]
    player_game.turnover = player_line[14]
    player_game.block = player_line[15]
    player_game.total_point = player_line[16]

    return player_game
  end

  private
  def score_lines
    @score_lines unless @score_lines.nil?
    score_table = (@doc%"tr.TSN1").next_sibling%"tr/td/table"
    lines = (score_table/"tr").collect do |tr|
      (tr/"td.TSN5").collect { |td| td.inner_text }
    end
    @score_lines = lines[1..2]
  end

  def final_score(index)
    score_lines[index][-1].to_i
  end

  def scores_by_period(index)
    score_lines[index][1...-1].map { |e| e.to_i }
  end

  def team_table(index)
    child_index = (index == 0) ? 3 : 5
    (@doc%"tr.TSN1").parent%"tr:nth(#{child_index})/td/table"
  end

  def team_total_lines(index)

    tl = (team_table(index)/"tr/td.TSN4").collect { |td| td.inner_text.to_i }

    tl[1..-1] # ignore the first 0 which comes from to 'TOTAL'.to_i
  end

  def team_rebounds(index)
    return 0 if player_stats(index)[-1][0].strip != 'TEAM'
    player_stats(index)[-1][10]
  end

  def team_turnovers(index)
    return 0 if player_stats(index)[-1][0].strip != 'TEAM'
    player_stats(index)[-1][14]
  end

  def team_score_tables
    if @team_tables.nil?
      @team_tables = (@doc/"tr.ysptblbdr3").map { |e| e.parent }
    end
    @team_tables
  end

  def player_stats(index)
    pl = (team_table(index)/"tr").select do |tr|
      (tr/"td.TSN1").any? || (tr/"td.TSN5").any?
    end

    pl.map do |tr|
      (tr/"td").collect do |td|
        (td.inner_text =~ /^\d+$/) ? td.inner_text.to_i : td.inner_text
      end
    end
  end
end

