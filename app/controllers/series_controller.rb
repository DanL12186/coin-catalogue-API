class SeriesController < ApplicationController
  def filter_series
    render json: Series.select(:name, :generic_img_url, :denomination, :date_range).where(denomination: params[:denomination])
  end
end