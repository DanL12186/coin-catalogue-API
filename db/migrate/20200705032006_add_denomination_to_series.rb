class AddDenominationToSeries < ActiveRecord::Migration[6.0]
  def change
    add_column :series, :denomination, :string, default: "", null: false
  end
end
