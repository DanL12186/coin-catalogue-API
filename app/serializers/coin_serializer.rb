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
             :denomination,
             :diameter,
             :metal_composition
end