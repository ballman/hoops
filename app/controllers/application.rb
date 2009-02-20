# The filters added to this controller will be run for all controllers in the application.
# Likewise will all the methods added be available for all controllers.
class ApplicationController < ActionController::Base
  helper :calendar

  before_filter :authorize, :only => [ :fox_loader, :cstv_loader, :loader,
  :parse, :parse_all, :move_player_line_into_edit, :save_player_game,
  :update_player_game, :_parse_game, :add_item, :add, :move_into_edit,
  :remove_from_team, :save, :update, :create ]

  def authorize
    redirect_to :back unless session[:authorized]
  end

  def login
    session[:authorized] = ('tricycle' == params[:key]) if params[:key]
    redirect_to :controller => 'team', :action => 'list'
  end

  # WTF???  ---  try, try again --- new subclipse????
end
