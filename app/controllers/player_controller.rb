class PlayerController < ApplicationController

  def list
    @team = Team.find(params[:id])
  end

  def add
    @player = Player.new(params[:player])
    @team = Team.find(@player.team_id)
    render :action => 'list'
  end

  def move_into_edit
    @player = Player.find(params[:id])
    @team = @player.team.id
    render(:partial => 'form')
  end

  def save
    if params[:id].nil?
      create
    else
      update
    end
  end

  def update
    @player = Player.find(params[:id])
    team_id = @player.team.id
    if @player.update_attributes(params[:player])
      flash['notice'] = 'Player was successfully updated.'
      @player = Player.new
    end
    redirect_to_list(team_id)
  end

  def create
    @player = Player.new(params[:player])
    @player.rosters = [Roster.new({:team_id => params[:team_id], :year => CURRENT_YEAR, :player_id => @player.id})]
    if @player.save
      flash['notice'] = 'Player was successfully created.'
      @player = Player.new
    end
    redirect_to_list(params[:team_id])
  end

  def remove_from_team
    @player = Player.find(params[:id])
    if @player.remove_from_current_roster
      flash['notice'] = 'Player was successfully removed from this team.'
    end
    redirect_to_list(params[:team_id])
  end

  private
  def redirect_to_list(team_id)
    redirect_to :action => 'list', :id => team_id
  end
end
