class Series < ApplicationRecord
  has_many :coins

  def self.all_series
    cache_key = "all_series#{Time.now.day}"

    Rails.cache.fetch(cache_key, expires_in: 24.hours) do
      Series.all
    end
  end
end
