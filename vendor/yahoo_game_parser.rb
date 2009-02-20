#!/usr/bin/ruby
require 'hpricot'

class YahooGameParser
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
    (@doc/"td.yspscores/b/a").collect do | team_link |
      [team_link.inner_text,
      team_from_link(team_link.get_attribute('href'))]
    end
  end

  def team_from_link(link)
    if (link =~ /teams\/(.+)/)
      Team.find(:first, :conditions => [ "yahoo_code = ?", $1])
    end
  end

  def home_scores_by_period
    all_scores = scores_by_period
    all_scores[all_scores.length/2 .. -1]
  end

  def home_final_score
    final_scores[1]
  end

  def home_total_line
    team_total_lines(1)
  end

  def home_team_rebound
    team_rebounds(1)
  end

  def home_team_turnover
    0
  end

  def home_team_game(team)
    new_team_game(team, home_total_line,
                  home_scores_by_period, home_final_score,
                  home_team_turnover, home_team_rebound)
  end

  def visit_scores_by_period
    all_scores = scores_by_period
    all_scores[0 ... all_scores.length/2]
  end

  def visit_final_score
    final_scores[0]
  end

  def visit_total_line
    team_total_lines(0)
  end

  def visit_team_rebound
    team_rebounds(0)
  end

  def visit_team_turnover
    0
  end

  def visit_team_game(team)
    new_team_game(team, visit_total_line,
                  visit_scores_by_period, visit_final_score,
                  visit_team_turnover, visit_team_rebound)
  end

  def new_team_game(team, team_line, scores, total_score, team_turnover, team_rebound)
    team_game = YahooTeamGame.new
    team_game.team = team

    (team_game.half1_point, team_game.half2_point, team_game.ot1_point,
     team_game.ot2_point, team_game.ot3_point, team_game.ot4_point, team_game.ot5_point) = scores.fill(0, scores.length .. 6)
    team_game.total_point = total_score

    team_game.minutes = team_line[1]
    (team_game.fgm, team_game.fga) = team_line[2].split(/-/)
    (team_game.tpm, team_game.tpa) = team_line[3].split(/-/)
    (team_game.ftm, team_game.fta) = team_line[4].split(/-/)
    team_game.offense_rebound = team_line[5]
    team_game.total_rebound = team_line[6]
    team_game.assist = team_line[7]
    team_game.turnover = team_line[8]
    team_game.steal = team_line[9]
    team_game.block = team_line[10]
    team_game.foul = team_line[11]
    team_game.team_turnover = 0
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
    player_stats(team_index).collect do | stats |
      new_player_game(stats)
    end
  end


  def new_player_game(player_line)
    player_game = YahooPlayerGame.new

    player_game.player_name = player_line[0]
    player_game.minutes = player_line[1]
    (player_game.fgm, player_game.fga) = player_line[2].split(/-/)
    (player_game.tpm, player_game.tpa) = player_line[3].split(/-/)
    (player_game.ftm, player_game.fta) = player_line[4].split(/-/)
    player_game.offense_rebound = player_line[5]
    player_game.total_rebound = player_line[6]
    player_game.assist = player_line[7]
    player_game.turnover = player_line[8]
    player_game.steal = player_line[9]
    player_game.block = player_line[10]
    player_game.foul = player_line[11]
    player_game.total_point = player_line[12]

    return player_game
  end

  private
  def final_scores
    (@doc/"tr.ysptblclbg5/td.ysptblclbg6/span").collect do |e|
      e.inner_text.to_i if (e.inner_text =~ /^\d+$/)
    end.compact
  end

  def scores_by_period
    (@doc/"tr.ysptblclbg5/td.yspscores").collect do |e|
      e.inner_html.to_i if e.inner_html =~ /^\d+/
    end.compact
  end

  def team_total_lines(index)
    (team_score_tables[index]/"tr.ysptblclbg5/td").collect do |stats|
      stats.inner_text.sub!(/[^\d-]*/, '').sub!(/[^\d-]*$/, '')
    end
  end

  def team_rebounds(index)
    rows =(team_score_tables[index]/"tr:last-child/td/b[text()*='Team Reb']")
    rows[0].parent.inner_text.match(/\d+/m).to_s.to_i
  end

  def team_score_tables
    if @team_tables.nil?
      @team_tables = (@doc/"tr.ysptblbdr3").map { |e| e.parent }
    end
    @team_tables
  end

  def player_stats(index)
    t = team_score_tables[index]
    p = (t/"tr").select { | tr | tr.get_attribute('class') =~ /ysprow[12]/ }
    p.collect { |r| (r/"td").collect { |td| td.inner_text.gsub(/&nbsp;/,'')}}
  end
end
