class CoinsController < ApplicationController

  def show
    # year, mintmark = params[:year_and_mintmark].split('-')
    year = params[:year_and_mintmark].to_i
    mintmark = params[:year_and_mintmark].match(/[SDOP]|C{1,2}$/i).to_s.upcase
    mintmark = nil if mintmark.empty?

    coin = Coin.find_by(year: year, mintmark: mintmark, denomination: params[:denomination])

    if coin
      render json: coin
    else
      render status: 404
    end
  end

  #returns a subset of coins based on query params
  def filter_coins
    result = Coin.select(:year, :mintmark, :denomination, :category, :mintage, :generic_img_url, :metal_composition, :pcgs_num, :id, :series)
                 .where(coin_params.reject { | _, v | v.empty? })
    
    #render json: CoinSerializer.new(result, { fields: { coin: [:year, :mintmark] } })
    if result.empty?
      render status: 404
    else
      render json: CoinSerializer.new(result).serializable_hash[:data]
    end
  end

  private
  
    def coin_params
      params.permit(:denomination, :year, :series)
    end

end
