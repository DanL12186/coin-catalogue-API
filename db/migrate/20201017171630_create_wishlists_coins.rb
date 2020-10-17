class CreateWishlistsCoins < ActiveRecord::Migration[6.0]
  def change
    create_table :wishlists_coins do |t|
      t.integer :wishlist_id
      t.integer :coin_id

      t.string :condition, default: nil

      t.timestamps
    end
  end
end