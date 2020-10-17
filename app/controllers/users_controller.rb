class UsersController < ApplicationController

  def create
    puts params
    user = User.new(user_params)
    user.save ? (render status: 201) : (render json: user.errors.to_json)
  end

  private

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end
