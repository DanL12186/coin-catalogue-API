class MultiCoinSerializer
  include JSONAPI::Serializer
  attributes :year, :mintmark, :denomination, :mintage, :series

  attribute :pcgs_total do | coin |
    coin.pcgs_population['total']
  end

end