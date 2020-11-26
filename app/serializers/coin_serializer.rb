class CoinSerializer
  include JSONAPI::Serializer
  attributes :id,
             :year,
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
             :next_coin,
             :prev_coin,
             :mass

  attribute :survival_estimate, &:estimated_survival_rates

  attribute :pcgs_total do | coin |
    coin.pcgs_population['total']
  end
end