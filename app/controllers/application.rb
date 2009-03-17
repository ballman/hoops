# The filters added to this controller will be run for all controllers in the application.
# Likewise will all the methods added be available for all controllers.
class ApplicationController < ActionController::Base
  helper :calendar

  before_filter :authorize, :only => [ :foo ]

  def authorize
    redirect_to :back unless session[:authorized]
  end

  def login
    session[:authorized] = ('tricycle' == params[:key]) if params[:key]
    redirect_to :controller => 'team', :action => 'list'
  end

  # WTF???  ---  try, try again --- new subclipse????
end
