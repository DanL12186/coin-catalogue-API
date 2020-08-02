class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }

  # has_many :wishlists
  # has_many :coin_collections

  # has_many :wishlist_coins, through: :wishlists, source: :coins
  # has_many :coins, through: :coin_collections
end
