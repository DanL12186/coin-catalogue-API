class CoinSerializer
  include JSONAPI::Serializer
  attributes :id, :year, :mintmark, :denomination, :category, :mintage, :generic_img_url, :metal_composition, :pcgs_num, :series, :designer, :pcgs_population
end