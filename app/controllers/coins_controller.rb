class CoinsController < ApplicationController

  def show
    # year, mintmark = params[:year_and_mintmark].split('-')
    year = params[:year_and_mintmark].to_i
    mintmark = params[:year_and_mintmark].match(/(?<=\-)\D+\d*$/i).to_s.titlecase
    mintmark = "CC" if mintmark.match?(/^cc/i)
    mintmark = nil if mintmark.empty?

    coin = Coin.find_by(year: year, mintmark: mintmark, denomination: params[:denomination])
    # binding.pry
    if coin
      render json: CoinSerializer.new(coin).serializable_hash[:data][:attributes]
    else
      render status: 404
    end
  end

  #returns a subset of coins based on query params
  def filter_coins
    result = Coin.select(:year, :mintmark, :denomination, :mintage, :series, :pcgs_population)
                 .where(coin_params.reject { | _, v | v.empty? })
    
    #render json: CoinSerializer.new(result, { fields: { coin: [:year, :mintmark] } })
    if result.empty?
      render status: 404
    else
      render json: MultiCoinSerializer.new(result).serializable_hash[:data].map! { | coin | coin[:attributes] }
    end
  end

  private
  
    def coin_params
      params.permit(:denomination, :year, :series)
    end

end
