class PlayerGame < ActiveRecord::Base
  belongs_to :player
  belongs_to :team_game
  belongs_to :game

  def to_s
    sprintf("%-20s %3d %3d-%3d %3d-%3d %3d-%3d %3d %3d %3d %3d %3d %3d %3d %3d",
            self.player_name, self.minutes, self.fgm, self.fga, self.ftm,
            self.fta, self.tpm, self.tpa, self.offense_rebound,
            self.total_rebound, self.assist, self.steal,
            self.block, self.turnover, self.foul, self.total_point)
  end

  def different_stats(other)
    different = Array.new
    attribute_names.each do | attr |
      if (attr !~ /.*id$/ && attr != 'player_name' &&
          self[attr] != other[attr])
        different << sprintf("[%s]  This: %s  other: %s", attr, self[attr],
                             other[attr])
      end
    end
    return different
  end

  def validate_stats
    valid_errors = Array.new
    valid_errors << validate_scoring
    valid_errors << validate_ft_shooting
    valid_errors << validate_fg_shooting
    valid_errors << validate_tp_shooting
    valid_errors << validate_rebounds
    valid_errors << validate_foul
    valid_errors << validate_correct_player
    return valid_errors.compact.flatten
  end

  def validate_scoring
    if (total_point != 2 * fgm + tpm + ftm)
      sprintf("[%s, %s] fgm:%d ftm:%d tpm: %d != %d", player.last_name,
              player.first_name, fgm, ftm, tpm, 2*fgm+tpm+ftm, total_point)
    end
  end

  def validate_ft_shooting
    sprintf("[%s, %s] ftm(%d) is more than fta(%d).", player.last_name,
            player.first_name, ftm, fta) if (ftm > fta)
  end

  def validate_fg_shooting
    sprintf("[%s, %s] fgm(%d) is more than fga(%d).", player.last_name,
            player.first_name, fgm, fga) if (fgm > fga)
  end

  def validate_tp_shooting
    sprintf("[%s, %s] tpm(%d) is more than tpa(%d).", player.last_name,
            player.first_name, tpm, tpa) if (tpm > tpa)
  end

  def validate_rebounds
    sprintf("[%s, %s] offense_rebound(%d) is more than total(%d).",
            player.last_name, player.first_name, offense_rebound,
            total_rebound) if (offense_rebound > total_rebound)
  end

  def validate_foul
    sprintf("[%s, %s] fouls(#{foul}) is more than 5.", player.last_name,
            player.first_name, foul) if (foul > 5)
  end

  def validate_correct_player
    stripped_name = player_name
    stripped_name = $1 if player_name =~ /(.*), [FCGfcg]$/
    return "#{stripped_name} does not match #{player.first_name} #{player.last_name} [#{boxscore_name}]" unless stripped_name.downcase == boxscore_name.downcase
  end

  def ==(other)
    (self.type            == other.type &&
     self.minutes         == other.minutes &&
     self.fgm             == other.fgm &&
     self.fga             == other.fga &&            
     self.tpm             == other.tpm &&            
     self.tpa             == other.tpa &&            
     self.fta             == other.fta &&            
     self.ftm             == other.ftm &&            
     self.offense_rebound == other.offense_rebound &&
     self.total_rebound   == other.total_rebound &&
     self.assist          == other.assist &&
     self.steal           == other.steal &&
     self.block           == other.block &&
     self.turnover        == other.turnover &&
     self.foul            == other.foul &&
     self.total_point     == other.total_point &&
     self.player_name     == other.player_name)
  end
end
