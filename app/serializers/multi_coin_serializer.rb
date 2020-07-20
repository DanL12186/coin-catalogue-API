class MultiCoinSerializer
  include JSONAPI::Serializer
  attributes :year, 
             :mintmark, 
             :denomination, 
             :mintage, 
             :series, 
             :special_designation

  attribute :pcgs_total do | coin |
    coin.pcgs_population['total']
  end

  attribute :survival_estimate, &:estimated_survival_rates
end