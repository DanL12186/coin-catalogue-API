class CreateGoldAndSilverPrices < ActiveRecord::Migration[6.0]
  def change
    create_table :gold_and_silver_prices do |t|
      t.float :gold
      t.float :silver
      t.date :date_retrieved
      
      t.timestamps
    end
  end
end
