class Game < ActiveRecord::Base
  belongs_to :home_team, :class_name => "Team", :foreign_key => "home_team_id"
  belongs_to :visit_team, :class_name => "Team", :foreign_key => "visit_team_id"
  has_many   :team_games
  has_many  :game_files

  def self.find_or_create(played_on, visit_team, home_team)
    game = Game.find(:first,
                     :conditions => [ 'played_on = ? and visit_team_id = ? and home_team_id = ?',
                                      played_on, visit_team.id, home_team.id ])
    if (game.nil?)
      game = Game.new
      game.played_on = played_on
      game.visit_team = visit_team
      game.home_team = home_team
      game.team_games = Array.new
    end

    return game
  end

  def home_team_game
    team_games[1]
  end

  def visit_team_game
    team_games[0]
  end

  def home_team_game=(team_game)
    team_games[1] = team_game
  end

  def visit_team_game=(team_game)
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

  def visit_team_game_for_type(klass)
    team_game_for_type(klass, visit_team)
  end

  def team_game_for_team_and_type(team, klass)
    return team_game_for_type(klass, team)
  end

  def team_games_for_team(team)
    team_games.find(:all,
                    :conditions => ['team_id = ?', team],
                    :order => 'id desc')
  end

  def opp_team_game_for_team_and_type(team, klass)
    opp_team = (team == home_team) ? visit_team : home_team
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
    team_games.find(:all,
      :conditions => ['type= ?', klass.to_s]).inject(true) do | same, team_game|
        same &&= team_game.different_stats(team_game_for_type(MasterTeamGame,
                                                              team_game.team)).empty?
    end
  end

  def win?(team, type=MasterTeamGame)
    home_team_game = home_team_game_for_type(type)
    visit_team_game = visit_team_game_for_type(type)
    if (team == home_team_game.team &&
        home_team_game.total_point > visit_team_game.total_point)
        return true
    end

    if (team == visit_team_game.team  &&
        home_team_game.total_point < visit_team_game.total_point)
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
    team_games.find(:first, :conditions => ['team_id = ? and type = ?',
                                            team, klass.to_s])
  end
end
