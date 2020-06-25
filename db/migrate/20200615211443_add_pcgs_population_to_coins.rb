class AddPcgsPopulationToCoins < ActiveRecord::Migration[6.0]
  def change
    add_column :coins, :pcgs_population, :json, default: {}
  end
end
