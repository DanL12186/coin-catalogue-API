class AddNextAndPreviousCoinToCoins < ActiveRecord::Migration[6.0]
  def change
    add_column :coins, :next_coin, :string
    add_column :coins, :prev_coin, :string
  end
end
