class NewPlayerController < ApplicationController
  def list
    @team = Team.find(params[:id])

    @not_on_roster_any_more = players_not_in_new_players(@team)
    
    @last_years_player_hash = @team.new_players.inject({}) do|hash, np|
      hash[np] = np.find_matching_player(@team.last_season_players)
      hash
    end

    @other_team_last_year_hash = @team.new_players.inject({}) do |hash, np|
       hash[np] = find_player_on_other_teams(np) if @last_years_player_hash[np].nil?
       hash
    end
  end

  def create_player_and_add_to_roster
    new_player = NewPlayer.find(params[:id])
    player_attr = new_player.attributes
    player_attr.delete("team_id")
    player = Player.new(player_attr)
    if player.save
      Roster.create!({:team_id => params[:team_id], :year => CURRENT_YEAR,
                       :player => player})
      new_player.destroy
      flash['notice'] = 'Player successfully created and added to roster.'
    end
    redirect_to_list(params[:team_id])
  end

  def update_player_and_add_to_roster
    new_player = NewPlayer.find(params[:id])
    player_attr = new_player.attributes
    player_attr.delete("team_id")
    player = Player.find(params[:player_id])
    if player.update_attributes!(player_attr)
      Roster.create!({:team_id => params[:team_id], :year => CURRENT_YEAR,
                       :player => player})
      new_player.destroy
      flash['notice'] = 'Player successfully updated and added to roster.'
    end
    redirect_to_list(params[:team_id])
  end

  private
  def find_player_on_other_teams(player)
    other_players_with_same_name = Player.find(:all, :conditions => {:first_name => player.first_name,
                                                                    :last_name => player.last_name})
    other_players_with_same_name.inject({}) do | hash, player |
      max_roster = player.rosters.max_by { |r| r.year }
      hash[player] = max_roster
      hash
    end
  end

  def players_not_in_new_players(team)
    team.last_season_players.select do |p|
      team.new_players.select { |np| np.first_name == p.first_name && np.last_name == p.last_name }.empty?
    end
  end
  
  def redirect_to_list(team_id)
    redirect_to :action => 'list', :id => team_id
  end

end
