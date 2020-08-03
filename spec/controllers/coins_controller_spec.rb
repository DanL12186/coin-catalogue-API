require 'rails_helper'

RSpec.describe CoinsController, type: :controller do
  let(:valid_coin) { 
    Coin.create(year: 1907, denomination: '$20', series: "Liberty Head Double Eagle", mintmark: "D", special_designation: "", category: "Double Eagles") 
  }

  describe 'validation tests' do
    context 'GET #show' do
    
      context 'with empty params' do
        it 'returns a 404 not found response' do
          get :show

          expect(response.status).to eq(404)
        end
      end

      context 'with valid params' do
        it 'returns a 200 success response in JSON format' do
          get :show, params: valid_coin.attributes

          expect(response).to be_successful
          expect(response.content_type).to eq "application/json; charset=utf-8"
        end
      end
      
    end

    context 'GET #filter_coins' do
      context 'with empty params' do
        it 'returns a 404 not found response' do
          get :filter_coins

          expect(response.status).to eq(404)
        end
      end
    end
  end

end
