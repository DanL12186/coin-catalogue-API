class GoldAndSilverPrice < ApplicationRecord
  def self.prices
    cache_key = "gold_and_silver_prices#{Time.now.day}"

    Rails.cache.fetch(cache_key, expires_in: 24.hours) do
      GoldAndSilverPrice.first.to_json
    end
  end
end