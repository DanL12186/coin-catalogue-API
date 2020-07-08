class CoinSerializer
  include JSONAPI::Serializer
  attributes :year,
             :mintmark,
             :denomination,
             :category,
             :mintage,
             :pcgs_num,
             :series,
             :designer,
             :pcgs_population,
             :price_table,
             :denomination,
             :diameter,
             :metal_composition,
             :special_designation,
             :generic_img_url,
             :mass

  attribute :pcgs_total do | coin |
    coin.pcgs_population['total']
  end
end