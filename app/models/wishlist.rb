class Wishlist < ApplicationRecord
  belongs_to :user
  has_many :wishlists_coins
  has_many :coins, through: :wishlists_coins
end