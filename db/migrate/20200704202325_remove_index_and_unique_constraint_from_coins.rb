class RemoveIndexAndUniqueConstraintFromCoins < ActiveRecord::Migration[6.0]
  def change
    remove_index :coins, name: "index_coins_on_series_year_mintmark_and_special_designation"
  end
end
