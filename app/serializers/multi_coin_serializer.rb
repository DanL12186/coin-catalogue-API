class MultiCoinSerializer
  include JSONAPI::Serializer
  attributes :year, 
             :mintmark, 
             :denomination, 
             :mintage, 
             :series, 
             :special_designation,
             :estimated_survival_rates

  attributes :pcgs_total do | coin |
    coin.pcgs_population['total']
  end

end