class TeamController < ApplicationController
  def list
    @conferences = Conference.find.all
  end

  def tourney
    @teams = Team.find_all_by_in_64(true).sort_by {|t| t.name }
  end

  def show
    @team = Team.find(params[:id])
    @rank = TeamRanks.find_by_team_id(@team.id)
    @opp_rank = TeamFoeRanks.find_by_team_id(@team.id)
    @diff_rank = TeamDiffRanks.find_by_team_id(@team.id)
    @games = Game.current.where('home_team_id = ? or away_team_id = ?',
                                @team.id, @team.id).order(:played_on).all
  end

  def breakdown
    @team = Team.find(params[:id])
    @games = Game.current.where('home_team_id = ? or away_team_id = ?',
                                @team.id, @team.id).order(:played_on).all
  end

  def save
    if params[:id].nil?
      create
    else
      update
    end
  end

  def update
    @team = Team.find(params[:id])
    if @team.update_attributes(params[:team])
      flash['notice'] = 'Team was successfully updated.'
    end
    redirect_to :action => 'show', :id => @team.id
  end

  def create
    @team = Team.new(params[:team])
    if @team.save
      flash['notice'] = 'Team was successfully created.'
    end
    redirect_to :action => 'show', :id => @team.id
  end
end

