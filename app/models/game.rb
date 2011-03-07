class Game < ActiveRecord::Base
  belongs_to :home_team, :class_name => "Team", :foreign_key => "home_team_id"
  belongs_to :away_team, :class_name => "Team", :foreign_key => "away_team_id"
  has_many   :team_games
  has_many   :master_team_games
  has_many  :game_files

  scope :current, lambda { { :conditions => [ 'played_on > ?', Date.new(CURRENT_YEAR, 11, 1)] }}
  
  def self.find_or_create(played_on, away_team, home_team)
    game = Game.where(:played_on => played_on, :away_team_id => away_team.id,
                      :home_team_id => home_team.id).first
    if (game.nil?)
      game = Game.new
      game.played_on = played_on
      game.away_team = away_team
      game.home_team = home_team
      game.team_games = Array.new
    end

    return game
  end

  def home?(team)
    home_team == team
  end
  
  def away?(team)
    away_team == team
  end
  
  def home_team_game
    team_games[1]
  end

  def away_team_game
    team_games[0]
  end

  def home_team_game=(team_game)
    team_games[1] = team_game
  end

  def away_team_game=(team_game)
    team_games[0] = team_game
  end

  def get_number_of_overtimes
    if (team_games[0].ot5_point > 0 || team_games[1].ot5_point > 0) then return 5 end
    if (team_games[0].ot4_point > 0 || team_games[1].ot4_point > 0) then return 4 end
    if (team_games[0].ot3_point > 0 || team_games[1].ot3_point > 0) then return 3 end
    if (team_games[0].ot2_point > 0 || team_games[1].ot2_point > 0) then return 2 end
    if (team_games[0].ot1_point > 0 || team_games[1].ot1_point > 0) then return 1 end
    return 0
  end

  def home_team_game_for_type(klass)
    team_game_for_type(klass, home_team)
  end

  def away_team_game_for_type(klass)

    team_game_for_type(klass, away_team)
  end

  def team_game_for_team_and_type(team, klass)
    return team_game_for_type(klass, team)
  end

  def team_games_for_team(team)
    team_games.where(:team_id => team).order('id desc').all
  end

  def opp_team_game_for_team_and_type(team, klass)
    opp_team = (team == home_team) ? away_team : home_team
    return team_game_for_type(klass, opp_team)
  end

  def game_file_for_type(klass)
    game_files.detect { | file | file.kind_of?(klass) }
  end

  def has_file_for_type?(klass)
    (game_file_for_type(klass).nil?)
  end

  def has_games_of_type?(klass)
    team_games.detect { | team_game | team_game.is_a?(klass) }
  end

  def valid_stats_for_type?(klass)
    team_games.inject(true) do | valid, team_game |
      valid &&= (!team_game.is_a?(klass) || team_game.validate_stats.empty?)
    end
  end

  def different_from_master_for_type?(klass)
    team_games.where(:type => klass.to_s).all.inject(true) do | same, team_game|
      same &&= team_game.different_stats(team_game_for_type(MasterTeamGame,
                                                            team_game.team)).empty?
    end
  end

  def win?(team, type=MasterTeamGame)
    home_team_game = home_team_game_for_type(type)
    away_team_game = away_team_game_for_type(type)
    if (team == home_team_game.team &&
        home_team_game.total_point > away_team_game.total_point)
        return true
    end

    if (team == away_team_game.team  &&
        home_team_game.total_point < away_team_game.total_point)
        return true
    end
    return false
  end

  def create_master_game(type=FoxTeamGame)
    return if has_games_of_type?(MasterTeamGame)
    tgs = team_games.collect do | team_game |
      team_game if team_game.is_a?(type)
    end
    raise "No games exist of type: #{type}" if team_games.nil?
    tgs.compact.each do |t|
      team_games << MasterTeamGame.create_from_other(t)
    end
  end

  def player_games_for_player(player)
    team_games.inject([]) { | pgs, tg |
      pgs << tg.player_games_for_player(player)
    }.compact
  end

  def player_games_for_team(team)
    tgs = team_games.select { |tg| tg.team == team }
    tgs.inject([]) do |pgs, tg|
      pgs += tg.player_games
    end
  end

  private
  def team_game_for_type(klass, team)
    team_games.where(:team_id => team, :type => klass.to_s).first
  end
end
