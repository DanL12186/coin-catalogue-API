class CreateCoins < ActiveRecord::Migration[6.0]
  def change
    create_table :coins do |t|
      t.integer :designer_id
      #should probably just have t.integer :series_id, and series has much of the below info, but this is simpler for now

      t.integer :year
      t.string :mintmark
      t.string :denomination #e.g. $1, $20, 50C, 25C, etc.
      t.string :category, null: false #e.g. Gold coins, dollars, quarters, nickels, dimes, pennies
      t.string :series #e.g. Liberty Head $20 1850-1907
      t.string :designer #e.g. Augustus St. Gauden, JBL, etc.
      t.integer :mintage  #total coins minted for the year/variety

      t.string :generic_img_url #generic low-res image for the series
      t.string :obverse_img_url
      t.string :reverse_img_url

      #should probably later be part of another class
      t.json :metal_composition #listed as percentages
      t.float :mass #mass in grams
      t.float :diameter #in mm
      
      t.json :price_table #a JSON object holding pricing information by grade and grading service
      t.json :price_history #history of prices (probably PCGS only, in which case perhaps just an array)
      
      t.json :recent_auction_prices #json of NGC and PCGS sales in USD w/dates
      t.json :estimated_survival_rates #at all grades, MS60 and MS65

      t.text :comments #comments from experts

      #site data
      t.integer :pcgs_num
      t.integer :ngc_num

      t.timestamps
    end
  end
end