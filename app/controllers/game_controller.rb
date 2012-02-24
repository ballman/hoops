class GameController < ApplicationController
  def list
    @date = params[:id]
    @games = Game.where(:played_on => @date).all
    @unloaded_files = GameFile.where(:game_date => @date, :game_id => nil).all
    @validate = (params[:validate].nil?) ? false : true
  end

  def fox_loader
    @conference_id = params[:id]
    loader(FoxGameFetcher.new, FoxGameFetcher::URL, @conference_id)
  end

  def cstv_loader
    loader(CstvGameFetcher.new, CstvGameFetcher::URL)
  end

  def sports_network_loader
    loader(SportsNetworkGameFetcher.new, SportsNetworkGameFetcher::URL)
  end

  def yahoo_loader
    loader(YahooGameFetcher.new, YahooGameFetcher::URL)
  end

  def show
    @game = Game.find(params[:id])
    @type = Object.const_get(params[:type] || 'FoxTeamGame')
  end

  def parse
    game_file = GameFile.where(:source_id => params[:id],
                               :type => params[:type]).first
    _parse_game(game_file)
    redirect_to :action => 'list', :id => game_file.game_date
  end

  def parse_all
    (y, m, d) = params[:date].split("-")
    type = Object.const_get(params[:type])
    GameFile.where(:game_date => Date.civil(y.to_i, m.to_i,
                                            d.to_i)).all.each do | game_file |
      next if (!game_file.is_a?(type) || game_file.content.nil? ||
               game_file.content.length == 0)
      _parse_game(game_file)
    end
    redirect_to :action => 'list', :id => params[:date]
  end

  
  def move_player_line_into_edit
    @player_game = PlayerGame.find(params[:id])
    @players = @player_game.team_game.team.players.sort do
      | x, y | x.name <=> y.name
    end
    @player = @player_game.player
#    render(:partial => 'edit_player_game')
  end

  def save_player_game
    if params[:id].nil?
      create_player_game
    else
      update_player_game
    end
  end

  def add_player_game
    team_game = TeamGame.find(params[:id])
    team_game.add_player_game!(team_game.team.players.first, 'Added')
    redirect_to :action => 'show', :id => team_game.game.id,
                :type => team_game.class
  end

  def update_player_game
    @player_game = PlayerGame.find(params[:id])
    @player_game.player = Player.find(params[:player][:id])
    if (@player_game.update_attributes(params[:player_game]))
      flash['notice'] = sprintf('Player game for %s on %s',
                                @player_game.player_name,
                                @player_game.team_game.team.name)
    else
      puts "ERROR"
    end
    redirect_to :action => 'show', :id => @player_game.team_game.game.id,
                :type => @player_game.team_game.class
  end

  def load_master
    _load_master(params[:id], Object.const_get(params[:type]))
  end

  def edit_master
    @game = Game.find(params[:id])
  end

  def player_diff
    @player_games = TeamGame.find(params[:id]).game.player_games_for_player(params[:player])
  end

  def load_master_for_date
    (y, m, d) = params[:date].split("-")
    type = Object.const_get(params[:type]) 
    games = Game.where(:played_on => Date.civil(y.to_i, m.to_i, d.to_i)).all
    games.each do |game|
      _load_master(game.id, type)
    end
    redirect_to :action => 'list', :id => params[:date]
  end

  def update_master
    params[:id] =~ /^team_game_edit_(.*)_(\d+)$/
    team_game_id = $2.to_i
    stat = $1
    TeamGame.update(team_game_id, {stat.to_sym => params[:value]})
    render :layout=>false, :inline=> "<%= params[:value] %>"
  end

  def save_box_name_in_player
    player_game = PlayerGame.find(params[:id])
    player = Player.find(player_game.player_id)
      puts "ARB ---->  #{player_game.class}"
#    if player_game.is_a?(FoxPlayerGame)
#      player.update_attribute('fox_bs_name', params[:name])
#    elsif player_game.is_a?(YahooPlayerGame)
#      player.update_attribute('yahoo_bs_name', params[:name])
#    elsif player_game.is_a?(SportsNetworkPlayerGame)
#      player.update_attribute('sn_bs_name', params[:name])
    case player_game
    when FoxPlayerGame
      player.update_attribute('fox_bs_name', params[:name])
    when YahooPlayerGame
      player.update_attribute('yahoo_bs_name', params[:name])
    when SportsNetworkPlayerGame
      player.update_attribute('sn_bs_name', params[:name])
    else
      puts "ARB ----> none: #{player_game.class}"
    end

    redirect_to :action => 'show', :id => player_game.team_game.game.id,
                :type => player_game.team_game.class
  end
  #======================================================================
  private
  #======================================================================
  def loader(fetcher, url, conference_id = 'all')
    (y, m, d) = params[:date].split("-")
    fetcher.get_games(Date.civil(y.to_i, m.to_i, d.to_i), url, conference_id)
    redirect_to :action => 'list', :id => params[:date]
  end

  def _load_master(game_id, type)
    begin
      game = Game.find(game_id)
      game.create_master_game(type)
      game.save
    rescue
      flash[:notice] ||= Array.new
      flash[:notice] << "#{game_id}: #{$!}"
    end
  end

  def _parse_game(game_file)
    parser = if(game_file.is_a?(FoxGameFile))
               GameParser.new(game_file.content, game_file.game_date)
             elsif (game_file.is_a?(YahooGameFile))
               YahooGameParser.new(game_file.content, game_file.game_date)
             elsif (game_file.is_a?(SportsNetworkGameFile))
               SportsNetworkGameParser.new(game_file.content,
                                           game_file.game_date)
             end
    return unless (game_file.game.nil?)
    begin
      game = parser.parse
      if game.save
        game_file.game = game
        game_file.save
      end
    rescue
      flash[:notice] ||= Array.new
      flash[:notice] << "#{game_file.source_id}: #{$!}"
    end
  end
end
