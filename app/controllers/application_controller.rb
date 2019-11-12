class ApplicationController < ActionController::Base
  #debugger
  before_action :set_current_user
  protected
  def set_current_user
    @current_user ||= Moviegoer.where(:id => session[:user_id])
    redirect_to login_path and return unless session[:user_id]
    #@current_user
  end
end
