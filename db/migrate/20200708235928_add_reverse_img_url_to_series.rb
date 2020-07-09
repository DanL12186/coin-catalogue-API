class AddReverseImgUrlToSeries < ActiveRecord::Migration[6.0]
  def change
    add_column :series, :reverse_img_url, :string, default: ""
  end
end