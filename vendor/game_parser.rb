#!/usr/bin/ruby
require 'hpricot'

class GameParser
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
    teams = Array.new
    team_table = (@doc/"table.sbTeamsBg")
    (team_table/"tr.sbTeam td b a").each do | team_link |
      teams << [team_link.inner_html.sub(/\n/," "), team_from_link(team_link)]
    end

    return teams
  end

  def team_from_link(link)
    Team.find(:first, :conditions => [ "fox_code = ?", link.inner_text])
  end

  def home_scores_by_period
    all_scores = scores_by_period
    all_scores[all_scores.length/2 .. -1]
  end

  def home_final_score
    final_scores[1]
  end

  def home_total_line
    team_total_lines[1]
  end

  def home_team_rebound
    team_rebounds[1]
  end

  def home_team_turnover
    team_turnovers[1]
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
    team_total_lines[0]
  end

  def away_team_rebound
    team_rebounds[0]
  end

  def away_team_turnover
    team_turnovers[0]
  end

  def away_team_game(team)
    new_team_game(team, away_total_line,
                  away_scores_by_period, away_final_score,
                  away_team_turnover, away_team_rebound)
  end

  def new_team_game(team, team_line, scores, total_score, team_turnover, team_rebound)
    team_game = FoxTeamGame.new
    team_game.team = team

    (team_game.half1_point, team_game.half2_point, team_game.ot1_point,
     team_game.ot2_point, team_game.ot3_point, team_game.ot4_point, team_game.ot5_point) = scores.fill(0, scores.length .. 6)
    team_game.total_point = total_score

    team_game.minutes = team_line[1]
    (team_game.fgm, team_game.fga) = team_line[2].split(/-/)
    (team_game.ftm, team_game.fta) = team_line[3].split(/-/)
    (team_game.tpm, team_game.tpa) = team_line[4].split(/-/)
    team_game.offense_rebound = team_line[5]
    team_game.total_rebound = team_line[7]
    team_game.assist = team_line[8]
    team_game.steal = team_line[9]
    team_game.block = team_line[10]
    team_game.turnover = team_line[11]
    team_game.foul = team_line[12]
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

  def get_team_extras(data, tag, position)
    extra_stat = Array.new
    data.each do | table |
      table.elements.each('*/tr/td/b | tr/td/b') do | bold |
        if (bold.text == tag)
          extra_stat << bold.parent.texts.join('').strip
        end
      end
    end
    return extra_stat[position - 1]
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
    player_games = []
    player_tables[team_index].each do |tr |
      player_games << new_player_game((tr/"td").collect { |td| td.inner_text })
    end
    return player_games
  end


  def new_player_game(player_line)
    player_game = FoxPlayerGame.new

    player_game.player_name = player_line[0]
    player_game.minutes = player_line[1]
    (player_game.fgm, player_game.fga) = player_line[2].split(/-/)
    (player_game.ftm, player_game.fta) = player_line[3].split(/-/)
    (player_game.tpm, player_game.tpa) = player_line[4].split(/-/)
    player_game.offense_rebound = player_line[5]
    player_game.total_rebound = player_line[7]
    player_game.assist = player_line[8]
    player_game.steal = player_line[9]
    player_game.block = player_line[10]
    player_game.turnover = player_line[11]
    player_game.foul = player_line[12]
    player_game.total_point = player_line[13]

    return player_game
  end

  def final_scores
    sb = scoring_table
    (sb/"tr.sbTeam/td/div.scoreboxTotal").collect {|e| e.inner_html.to_i }
  end

  def scores_by_period
    sb = scoring_table
    scores = (sb/"tr.sbTeam/td:not(/div)").collect do |e|
      e.inner_html.to_i if e.inner_html =~ /^\d+/
    end
    scores.compact
  end

  def scoring_table
    (@doc/"table.sbTeamsBg")
  end

  def team_total_lines
    (team_tables/"tr.bgHigh").collect { | tr |
      (tr/"td").collect { | td | td.inner_html.match(/^[0-9\-]+/).to_s }
    }
  end

  def player_tables
    teams = team_tables.collect { |table| (table/"tr.bgC") }
  end

  def team_tables
    (@doc/"table.bgBdr")
  end

  def team_extras(extra_string)
    @doc.search("//tr/td/b[text()*='#{extra_string}']").collect do |e|
      e.parent.inner_html.match(/\d+/).to_s.to_i
    end
  end

  def team_rebounds
    team_extras("Team Rebounds")
  end

  def team_turnovers
    team_extras("Team Turnovers")
  end
end

