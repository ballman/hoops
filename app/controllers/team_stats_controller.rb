 class TeamStatsController < ApplicationController
  helper :team

  def list
    @foe = params[:foe]
    @teams = Team.all.inject({}) {|h,t| h[t.id] = t; h}
    case @foe
      when '1'
        @team_stats = Team.all.collect(&:opp_stats).compact.sort_by { |s| s.team.name }
      when 'diff'
        @team_stats = Team.all.collect(&:stats).compact.sort_by { |s| s.team.name }
        @foe_stats = Team.all.collect(&:opp_stats).compact.sort_by { |s| s.team.name }.inject({}) {|h,s| h[s.id] = s; h}
      else
        @team_stats = Team.all.collect(&:stats).compact.sort_by { |s| s.team.name }
    end
    @columns = TeamAverage.stat_columns
    @name_map = { 'offense_rebound' => 'oreb', 'total_rebound' => 'treb', 'turnover' => 't/o'}
  end

  def compare
    begin
      @teams = [ Team.find(params[:team1]), Team.find(params[:team2]) ]
    rescue
      @teams = [ Team.find(200), Team.find(247) ]  # Air Force vs. Alabama
    end

    # common foes
    games_1 = [ Game.current.find_all_by_home_team_id(@teams[0].id),
                Game.current.find_all_by_away_team_id(@teams[0].id) ].flatten
    games_2 = [ Game.current.find_all_by_home_team_id(@teams[1].id),
                Game.current.find_all_by_away_team_id(@teams[1].id) ].flatten

    common_ids = games_1.collect {|g| (g.home_team_id == @teams[0].id) ? g.away_team_id : g.home_team_id } & games_2.collect {|g| (g.home_team_id == @teams[1].id) ? g.away_team_id : g.home_team_id }

    @common_foes = [ games_1.select {|g| common_ids.include?(g.home_team_id) or common_ids.include?(g.away_team_id) } ,games_2.select {|g| common_ids.include?(g.home_team_id) or
                       common_ids.include?(g.away_team_id) } ].flatten.sort_by(&:played_on)

    @grouped_common_foes = @common_foes.inject({ }) do |h,g|
      name = ((g.home_team.name == @teams[1].name or g.home_team.name == @teams[0].name) ? g.away_team.name : g.home_team.name)

      h[name] ||= []
      h[name] << g
      h
    end

    # played each other
    @mutual_games = games_1.select {|g|
       g.home_team_id == @teams[1].id or g.away_team_id == @teams[1].id
    }.sort_by(&:played_on)

    # team stats
    @tourney_teams = Team.find_all_by_in_64(true).sort_by {|t| t.name }
    @stats = @teams.collect {|t| t.stats }
    @foe_stats = @teams.collect {|t| t.opp_stats }
    @ranks = @teams.collect {|t| TeamRanks.find_by_team_id(t.id) }
    @foe_ranks = @teams.collect {|t| TeamFoeRanks.find_by_team_id(t.id) }
    @diff_ranks = @teams.collect {|t| TeamDiffRanks.find_by_team_id(t.id) }

    @columns = TeamAverage.stat_columns
  end
end
