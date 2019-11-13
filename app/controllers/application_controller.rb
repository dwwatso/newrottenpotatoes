class ApplicationController < ActionController::Base
  before_action :set_current_user
  protected
  def set_current_user
    #debugger
    @current_user ||= Moviegoer.find_by(id: session[:user_id]) if session[:user_id]
    redirect_to login_path and return unless @current_user
  end
end
