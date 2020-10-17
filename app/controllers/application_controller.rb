class ApplicationController < ActionController::API
  def current_user
    session[:user_id] ? @current_user ||= User.find(session[:user_id]) : @current_user = nil
  end
end