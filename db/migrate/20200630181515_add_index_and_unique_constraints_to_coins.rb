class AddIndexAndUniqueConstraintsToCoins < ActiveRecord::Migration[6.0]
  def change
    add_index :coins, 
              [:series, :year, :mintmark, :special_designation],
              unique: true,
              name: 'index_coins_on_series_year_mintmark_and_special_designation'
  end
end