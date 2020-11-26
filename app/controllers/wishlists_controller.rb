class WishlistsController < ApplicationController

  def create
    Wishlist.create(wishlist_params)
  end

  def index
    user = User.find_by(name: params[:user_name])
    render json: Wishlist.where(user_id: user.id)
  end

  def show
    render json: Wishlist.find_by(id: params[:id]).coins
  end

  def update
  end

  def add_coin
    wishlist = Wishlist.find_by(id: params[:id])
    coin_id = params[:coin][:id]

    unless wishlist.coins.find_by(id: coin_id)
      WishlistsCoin.create(coin_id: coin_id, wishlist_id: wishlist.id)
      render status: 201
    end
  end

  private
    
    def wishlist_params
      params.require(:wishlist).permit(:name, :user_id)
    end

end
