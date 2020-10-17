class WishlistsController < ApplicationController
  def create
    Wishlist.create(wishlist_params)
  end

  def index
    user = User.find_by(name: params[:user_name])
    wishlists = Wishlist.where(user_id: user.id)

    render json: wishlists
  end

  private
    
    def wishlist_params
      params.require(:wishlist).permit(:name, :user_id)
    end

end
