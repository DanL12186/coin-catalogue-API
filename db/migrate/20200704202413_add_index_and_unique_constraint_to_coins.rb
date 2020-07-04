class AddIndexAndUniqueConstraintToCoins < ActiveRecord::Migration[6.0]
  def change
    add_index :coins, 
              [:denomination, :year, :mintmark, :special_designation],
              unique: true,
              name: 'index_coins_on_denomination_year_mintmark_and_designation'
  end
end