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
    @game.away_team_game = away_team_game(@game.away_team)
    @game.home_team_game = home_team_game(@game.home_team)
    @game.away_team_game.team_name = teams[0][0]
    @game.home_team_game.team_name = teams[1][0]

    @game.away_team_game.player_games = build_player_games(0)
    @game.home_team_game.player_games = build_player_games(1)

    @game.away_team_game.map_player_games
    @game.home_team_game.map_player_games
    @game
  end

  def get_teams
    (@doc/"td.yspscores/b/a").collect do | team_link |
      team = team_from_link(team_link.get_attribute('href'))
      raise ArgumentError, "Unable to find team: #{team_link.inner_text}" if (team.nil?)

      [team_link.inner_text, team]
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

  def away_scores_by_period
    all_scores = scores_by_period
    all_scores[0 ... all_scores.length/2]
  end

  def away_final_score
    final_scores[0]
  end

  def away_total_line
    team_total_lines(0)
  end

  def away_team_rebound
    team_rebounds(0)
  end

  def away_team_turnover
    0
  end

  def away_team_game(team)
    new_team_game(team, away_total_line,
                  away_scores_by_period, away_final_score,
                  away_team_turnover, away_team_rebound)
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
    team_game.team_turnover = team_turnover
    team_game.team_rebound = team_rebound
    team_game
  end

  def build_player_games(team_index)
    player_stats(team_index).collect do | stats |
      new_player_game(stats)
    end
  end

  def new_player_game(player_line)
    player_game = YahooPlayerGame.new

    player_game.player_name = player_line[0].sub(/^[^A-Za-z]+/, '')
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
    rows = (team_score_tables[index]/"tr:last-of-type/td/b[text()*='Team Reb']")
    (rows.nil? || rows[0].nil?) ? 0 : rows[0].parent.inner_text.match(/\d+/m).to_s.to_i
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
    p.collect { |r| (r/"td").collect { |td| td.inner_text.gsub(/\? */,'')}}
  end
end
