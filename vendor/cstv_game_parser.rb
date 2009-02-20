#!/usr/bin/ruby
class CstvGameParser
  def initialize(_raw_html, _played_on)
    @boxscore = ''
    @boxscore = $1.gsub(/<.*?>/, '') if (_raw_html =~ /<PRE>(.*)<\/PRE>/m)
    raise ArgumentError, "Can't find Boxscore data" if @boxscore == ''
    @played_on = _played_on
  end

  def parse
    game = get_game
    game.visit_team_game = build_team_game(0, game.visit_team)
    game.home_team_game = build_team_game(1, game.home_team)
    return game
  end

  # returns a game, existing or newly minted
  def get_game
    teams = get_teams
    Game.find_or_create(@played_on, teams[0], teams[1])
  end

  # returns an array containing two teams...  the first the visitor the second home
  def get_teams
    scores = get_team_scores
    [ (scores.length > 0) ? get_team_from_score_line(scores[0]) : nil,
      (scores.length > 1) ? get_team_from_score_line(scores[1]) : nil ]
  end

  def build_team_game(team_index, team)
    scores = get_scores_from_score_line(get_team_scores()[team_index])
    totals = get_total_lines()[team_index].split(' ')

    team_game = CstvTeamGame.new(:team => team,
                     :half1_point => scores[0], :half2_point => scores[1],
                     :ot1_point => scores[2], :ot2_point => scores[3],
                     :ot3_point => scores[4], :ot4_point => scores[5],
                     :ot5_point => scores[6], :total_point => scores[7],
                      :minutes => totals[1].to_i,
                     :fgm => totals[2].split('-')[0].to_i, :fga => totals[2].split('-')[1].to_i,
                     :tpm => get_tpm(team_index)['TOTAL'].to_i,
                     :tpa => get_tpa(team_index)['TOTAL'].to_i,
                     :ftm => totals[3].split('-')[0].to_i, :fta => totals[3].split('-')[1].to_i,
                     :offense_rebound => totals[4].split('-')[0].to_i,
                     :total_rebound => totals[4].split('-')[1].to_i,
                     :team_rebound => get_team_rebounds(team_index).to_i,
                     :assist => totals[5].to_i,
                     :steal => get_steals(team_index)['TOTAL'].to_i,
                     :block => get_blocks(team_index)['TOTAL'].to_i,
                     :turnover => get_turnovers(team_index)['TOTAL'].to_i,
                     :foul => totals[6].to_i, :team_name => team.name)
    team_game.player_games = build_player_games_for_team(team_index)
    team_game.map_player_games
    return team_game
  end

  def build_player_games_for_team(team_index)
    players = Array.new
    get_player_games(team_index).each do | player_line |
      next if (player_line.rindex(/[^ \d-]/).nil?)
      stats = player_line[player_line.rindex(/[^ \d-]/)+1..-1].split(' ')
      stats.insert(0, player_line[0..player_line.rindex(/[^ \d-]/)])
      players << CstvPlayerGame.new(:minutes => stats[1].to_i,
                                    :fgm => stats[2].split('-')[0].to_i,
                                    :fga => stats[2].split('-')[1].to_i,
                                    :ftm => stats[3].split('-')[0].to_i,
                                    :fta => stats[3].split('-')[1].to_i,
                                    :tpm => get_tpm(team_index)[stats[0]].to_i,
                                    :tpa => get_tpa(team_index)[stats[0]].to_i,
                                    :offense_rebound => stats[4].split('-')[0].to_i,
                                    :total_rebound => stats[4].split('-')[1].to_i,
                                    :assist  => stats[5].to_i,
                                    :steal => get_steals(team_index)[stats[0]].to_i,
                                    :block => get_blocks(team_index)[stats[0]].to_i,
                                    :turnover => get_turnovers(team_index)[stats[0]].to_i,
                                    :foul => stats[6].to_i,
                                    :total_point => stats[7].to_i,
                                    :player_name => stats[0])
    end
    return players
  end

  # Given a score line of the form:
  # TEAM NAME         40   30   -   70
  # Returns: the team which corresponds to the TEAM NAME (cstv code).
  #          nil, if a team does not exist for the cstv code (TEAM NAME).
  def get_team_from_score_line(_line)
    cstv_code = _line.match(/([^\d]+?) +\d/)[1] if (_line =~ /([^\d]+?) +\d/)
    cstv_code.gsub!(/&[Aa][Mm][Pp];/, '&')
    team = Team.find(:first, :conditions => ['cstv_code = ?', cstv_code])
    raise ArgumentError, "Unable to find team: #{cstv_code}" if (team.nil?)
    return team
  end

  # Given a score line of the form:
  # TEAM NAME         40   30   -   70
  # Returns: an array of the scores.  I.e. [ 40, 30, 70 ]
  def get_scores_from_score_line(_line)
    scores = _line.split.find_all { |i| i =~ /^\d+$/ }.collect { |i| i.to_i }
    total = scores[-1]
    scores.fill(0, -1, 9 - scores.length)
    scores[-1] = total
    return scores
  end

  # The boxscore will have the team score lines surrounded by lines of '-'s.
  # Returns: An array of team score lines of the form: TEAM NAME         40   30   -   70
  #          [0] is visitor and [1] is the home line
  def get_team_scores
    totals = @boxscore.split(/-----+\n/)
    totals[1].split(/\n/)
  end

  def get_stats_from_line(_line)
    _line.gsub(/-/, ' ').split.find_all { |i| i =~ /^\d+$/ }.collect { |i| i.to_i }
  end

  #----------------------------------------------------------------------------------------
  # The following all return a hash of the player's name in the extra information section
  # and an additional entry with the key of TOTAL for the team total.
  #----------------------------------------------------------------------------------------
  def get_turnovers(index)
    extra = get_box_extras()[index]
    return (extra =~ /Turnovers: *(\d+) *\(([^\)]*)\)\./) ? get_extra_stats($1.to_i, $2) :
                                                            { 'TOTAL' => 0 }
  end

  def get_blocks(index)
    extra = get_box_extras()[index]
    return (extra =~ /Blocked Shots: *(\d+) *\(([^\)]*)\)\./) ? get_extra_stats($1.to_i, $2) :
                                                                {'TOTAL' => 0}
  end

  def get_steals(index)
    extra = get_box_extras()[index]
    return (extra =~ /Steals: *(\d+) *\(([^\)]*)\)\./) ? get_extra_stats($1.to_i, $2) :
                                                         { 'TOTAL' => 0 }
  end

  def get_tpm(index)
    three_pointers = get_tp_raw(index)
    three_pointers.inject(Hash.new) do | acc, k |
      acc.merge({k[0] => k[1][0...k[1].index('-')].to_i })
    end
  end

  def get_tpa(index)
    three_pointers = get_tp_raw(index)
    three_pointers.inject(Hash.new) do | acc, k |
      acc.merge({k[0] => k[1][k[1].index('-') + 1 .. -1].to_i })
    end
  end

  def get_team_rebounds(index)
    extra = get_box_extras()[index]
    (extra =~ /\. *Team Rebounds: *(\d+)\./) ? $1.to_i : 0
  end

  def get_tp_raw(index)
    extra = get_box_extras()[index]
    return (extra =~ /3-Point Goals: *([\d-]+).*?\(([^\)]*)\)\./) ? get_extra_stats($1, $2) :
                                                                    { 'TOTAL' => 0 }
  end

  def get_extra_stats(total, stat_line)
    stats = Hash.new
    stats['TOTAL'] = total
    stat_line.split(/,/).each do | player |
      player.strip!
      next if (player == '')
      if (player =~ /(.*?) ([\d]+)$/)
        stats[$1] = $2.to_i
      elsif (player =~ /(.*?) ([\d-]+)$/)
        stats[$1] = $2
      elsif (player !~ /^[0-9]/)
        stats[player] = 1
      end
    end
    return stats
  end

  def get_box_extras
    extra_info = Array.new
    box_sections = @boxscore.split(/_+\n/)
    extra_info << $1.gsub("\n", ' ') if (box_sections[2] =~ /^((.|\n)*)\n[A-Za-z &;-]* +\(\d\d\d?\)/)
    extra_info << $1.gsub("\n", ' ') if (box_sections[4] =~ /^((.|\n)*?)\n-+/)
  end

  def get_player_games(index)
    box_sections = @boxscore.split(/_+\n/)

    index = 2 if (index != 0)
    players = Array.new
    box_sections[index].split(/\n/).each do | boxline |
      players << boxline if (boxline =~ /(.*) \d\d? +\d+-\d+ +\d+-\d+ +\d+-\d+ +\d+ +\d+ +\d+/)
    end
    return players
  end

  def get_total_lines
    totals = @boxscore.split(/_+\n/)
    return totals[1], totals[3]
  end

end
