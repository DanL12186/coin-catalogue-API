class WishlistsCoin < ApplicationRecord
  belongs_to :wishlist
  belongs_to :coin
end
