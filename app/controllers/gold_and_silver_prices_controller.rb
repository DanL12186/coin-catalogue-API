require 'open-uri'

class GoldAndSilverPricesController < ApplicationController
  
  def prices
    if GoldAndSilverPrice.prices.updated_at.before?(1.day.ago)
      update_prices
    else
      render json: GoldAndSilverPrice.prices
    end
  end

  #should only be called if gold and prices were last updated more than 24 hours ago
  def update_prices
    api_response = URI.open("https://metals-api.com/api/latest?access_key=#{ENV['GOLD_AND_SILVER_API_KEY']}&base=USD&symbols=XAU,XAG")

    response_hash = JSON.parse(api_response.read)

    if response_hash['success']
      gold_price     = (1 / response_hash['rates']['XAU']).round(2)
      silver_price   = (1 / response_hash['rates']['XAG']).round(2)
      retrieval_date = Date.parse(response_hash['date'])

      GoldAndSilverPrice.update(gold: gold_price, silver: silver_price, date_retrieved: retrieval_date)

      prices = GoldAndSilverPrice.first

      Rails.cache.write("gold_and_silver_prices#{Time.now.day}", prices)
      
      render json: prices
    else
      begin 
        error = response_hash['error']
        raise StandardError("Error Code #{error['code']}: #{error['type']} - #{error['info']}")
      rescue StandardError => error
        puts "drat"
      end
    end
  end

end