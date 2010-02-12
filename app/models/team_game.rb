class TeamGame < ActiveRecord::Base
  belongs_to :game
  belongs_to :team
  has_many :player_games
  before_save :set_nil_ots_to_zero

  def to_s
    sprintf("%20s %3d %3d-%3d %3d-%3d %3d-%3d %3d %3d %3d %3d %3d %3d %3d\n  Scoring: %2d %2d %2d %2d %2d %2d = %3d  TeamTO: %3d   Team Reb: %3d",
            self.team.name, self.minutes, self.fgm, self.fga, self.ftm, self.fta, self.tpm,
            self.tpa, self.offense_rebound, self.total_rebound, self.assist, self.steal,
            self.block, self.turnover, self.foul, self.half1_point, self.half2_point,
            self.ot1_point, self.ot2_point, self.ot3_point, self.ot4_point, self.total_point,
            self.team_turnover, self.team_rebound)
  end

  def fgp
    (fga > 0) ? fgm.to_f / fga.to_f : 0
  end

  def ftp
    (fta > 0) ? ftm.to_f / fta.to_f : 0
  end

  def tpp
    (tpa > 0) ? tpm.to_f / tpa.to_f : 0
  end

  def set_nil_ots_to_zero
    self.ot1_point = 0 if self.ot1_point.nil?
    self.ot2_point = 0 if self.ot2_point.nil?
    self.ot3_point = 0 if self.ot3_point.nil?
    self.ot4_point = 0 if self.ot4_point.nil?
    self.ot5_point = 0 if self.ot5_point.nil?
  end

  def different_stats(other)
#    puts "#{self.team.name}   -> game: #{self.game.id}"
    raise "bitches" if !other
    different = Array.new
    attribute_names.each do | attr |
      if (self.class == CstvTeamGame) && (attr =~ /rebound/)
      elsif (attr !~ /.*id$/ && attr !~ /^type$/ && attr != 'team_name' &&
          self[attr] != other[attr])
        different << sprintf("[%s]  This: %s  other: %s", attr, self[attr], other[attr])
      end
    end
#    puts different
    return different
  end

  # validation routines
  def validate_stats
    valid_errors = Array.new
    valid_errors << validate_score_breakdown
    valid_errors << validate_score_by_mades
    valid_errors << validate_player_totals
    valid_errors << validate_unique_players
    player_games.each { | player_game | valid_errors << player_game.validate_stats }
    return valid_errors.compact.flatten
  end

  def validate_score_breakdown
    "Score breakdown not valid: sums to #{half1_point + half2_point + ot1_point + ot2_point + ot3_point + ot4_point + ot5_point} not #{total_point}" if (total_point != half1_point + half2_point + ot1_point + ot2_point + ot3_point + ot4_point + ot5_point)
  end

  def validate_score_by_mades
    if (total_point != fgm * 2 + ftm + tpm )
      "Score by mades not valid.  Sums to #{fgm * 2 + ftm + tpm} not #{total_point}"
    end
  end

  def validate_player_totals
    errors = [:minutes, :fgm, :fga, :tpm, :tpa, :ftm, :fta, :total_rebound, :assist, :steal, :block, :turnover, :foul, :total_point].inject(Array.new) do | errors, stat |
      errors << validate_player_total_for_stat(stat)
    end
    errors.compact
  end

  def validate_unique_players
    errors = Array.new
    players = Hash.new(0)
    player_games.each { |player_game| players[player_game.player] += 1 }
    players.each do |player, count|
      if (count > 1)
        errors << "Duplicate player #{player.last_name}, #{player.first_name} [#{player.id}]"
      end
    end
    return errors
  end

  def map_player_games
    player_games.each do | player_game |
      player_game.player = find_player(player_game)
    end
  end

  def find_player(player_game)
    name = player_game.player_name
    name.strip!
    name = $1 if name =~ /(.*), [FGC]$/

    best_match = nil
    match_score = -1.0

    players = self.team.players
    players.each do | player |
      boxscore_name = boxscore_name(player)
      if (closeness(boxscore_name, name) > match_score)
        match_score = closeness(boxscore_name, name)
        best_match = player
      end
    end

    return best_match
  end

  def split_name(name)
    name = $1 if (name =~ /(.*),.*/)
    name = name.gsub(/\./, '') if name.count('.') == 1
    space = name.index(' ')
    return [name[0 .. space - 1], name[space + 1 .. -1]]
  end

  def validate_player_total_for_stat(stat)
    player_total = player_games.inject(0) { | total, player | total + player.send(stat) }
    team_total = self.send(stat)
    team_total -= team_rebound if (stat == :total_rebound)
    team_total -= team_turnover if (stat == :turnover)
    if (player_total != team_total)
      "Team total of #{stat} does not sum.  Players = #{player_total}   Team = #{team_total}"
    end
  end


  def player_games_for_player(player)
    player_games.find(:first,
                      :conditions => ['player_id = ?', player])
  end

  def ==(other)
    (self.minutes         == other.minutes &&                
     self.fgm             == other.fgm &&                  
     self.fga             == other.fga &&                      
     self.ftm             == other.ftm &&
     self.fta             == other.fta &&
     self.tpm             == other.tpm &&
     self.tpa             == other.tpa &&
     self.offense_rebound == other.offense_rebound &&
     self.total_rebound   == other.total_rebound &&
     self.assist          == other.assist &&
     self.steal           == other.steal &&
     self.block           == other.block &&
     self.turnover        == other.turnover &&
     self.foul            == other.foul &&
     self.half1_point     == other.half1_point &&
     self.half2_point     == other.half2_point &&
     self.ot1_point       == other.ot1_point &&
     self.ot2_point       == other.ot2_point &&
     self.ot3_point       == other.ot3_point &&
     self.ot4_point       == other.ot4_point &&
     self.total_point     == other.total_point &&
     self.team_turnover   == other.team_turnover &&
     self.team_rebound    == other.team_rebound)
  end
  private
  def closeness(string, other)
    string.downcase.lcs(other.downcase).length/string.length.to_f
  end
end
