class MultiSeriesSerializer
  include JSONAPI::Serializer
  attributes :name, :generic_img_url, :mass, :diameter, :metal_composition, :id
end