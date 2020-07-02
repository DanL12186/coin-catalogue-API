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

    return thickness * 10
    #g/cm^2
    square_density = Math.cbrt(coin_density) ** 2

    #mass/density/surface_area
    #(self.mass / self.surface_area / square_density).round(5) or... self.mass / square_density / 20

    #(self.mass / square_density).round(5)
    #self.surface_area / coin_density / self.mass
    #self.surface_area / square_density * self.mass    
  end

end
