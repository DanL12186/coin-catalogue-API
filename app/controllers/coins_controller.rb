class CoinsController < ApplicationController

  def show
    mintmark = params[:mintmark].upcase unless params[:mintmark].empty?
    
    coin = Coin.find_by(
      year: params[:year], 
      mintmark: mintmark, 
      denomination: params[:denomination], 
      special_designation: params[:special_designation]
    )

    if coin
      render json: CoinSerializer.new(coin).serializable_hash[:data][:attributes]
    else
      render status: 404
    end
  end

  #returns a subset of coins based on query params
  def filter_coins
    result = Coin.select(:year, :mintmark, :denomination, :mintage, :series, :pcgs_population, :special_designation)
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
