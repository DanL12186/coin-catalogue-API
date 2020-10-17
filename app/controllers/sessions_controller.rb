class SessionsController < ApplicationController

  def login
    user = User.find_by(name: session_params[:name])
    if user&.authenticate(session_params[:password])
      user = User.find_by(name: session_params[:name])
      session[:user_id] = user.id

      render json: { status: 200, username: user.name }
    else
      render status: 403
    end
  end

  private

  def session_params
    params.require(:user).permit(:password, :name)
  end

end