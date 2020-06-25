class ApplicationController < ActionController::API

  def home
    render json: { what: 'pewpew numismatics' }
  end

end