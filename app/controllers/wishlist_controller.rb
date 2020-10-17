class WishlistController < ApplicationController
  def create
    Wishlist.create(wishlist_params)
  end

  private
    
    def wishlist_params
      params.require(:wishlist).permit(:name, :user_id)
    end
    
end
