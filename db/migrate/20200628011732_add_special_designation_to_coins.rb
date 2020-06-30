class AddSpecialDesignationToCoins < ActiveRecord::Migration[6.0]
  def change
    add_column :coins, :special_designation, :string, default: "", null: false
  end
end