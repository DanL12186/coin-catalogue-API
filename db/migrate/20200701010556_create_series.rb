class CreateSeries < ActiveRecord::Migration[6.0]
  def change
    create_table :series do |t|
      #category can be determined from series name
      t.integer :designer_id, foreign_key: true
      t.string :name, null: false, unique: true

      t.string :generic_img_url
      t.string :date_range
      t.float :mass
      t.float :diameter
      t.json :metal_composition

      t.text :comments

      t.timestamps
    end
  end
end
