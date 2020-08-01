class Coin < ApplicationRecord
  # belongs_to :designer
  #belongs_to :series

  #g/cm^3
  COPPER_DENSITY = 8.96
  SILVER_DENSITY = 10.49
  GOLD_DENSITY   = 19.32

  #in cm^2
  def surface_area
    Math::PI * ((self.diameter / 2.0) ** 2)
  end

  #in cm
  def estimate_thickness
    #g/cm^3
    coin_density = [
      COPPER_DENSITY * 0.01 * (self.metal_composition['copper'] || 0),
      SILVER_DENSITY * 0.01 * (self.metal_composition['silver'] || 0),
      GOLD_DENSITY   * 0.01 * (self.metal_composition['gold']   || 0)
    ].sum

    volume = self.mass / coin_density
    thickness = volume / self.surface_area

    thickness * 100
  end

end
