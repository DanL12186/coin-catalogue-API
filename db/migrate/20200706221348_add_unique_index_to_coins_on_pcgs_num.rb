class AddUniqueIndexToCoinsOnPcgsNum < ActiveRecord::Migration[6.0]
  def change
    add_index :coins, :pcgs_num, unique: true
  end
end