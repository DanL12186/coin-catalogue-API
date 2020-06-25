class CoinSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :year, :mintmark, :denomination, :category, :mintage, :generic_img_url, :metal_composition, :pcgs_num
end