require 'rails_helper'

RSpec.describe Coin, type: :model do
  let(:valid_coin) { 
    Coin.new(year: 1907, 
             denomination: '$20', 
             series: "Liberty Head Double Eagle", 
             mintmark: "D", 
             special_designation: "", 
             category: "Double Eagles",
             pcgs_num: 1221
            ) 
  }

  describe 'database validation tests' do

    context "valid coins" do 
      it "allows valid coin to be created" do
        expect(valid_coin.save).to eq(true)
      end
    end

    context "invalid coins" do
      it "raises error if a coin would be created without category" do
        coin = Coin.new(denomination: '50C')

        expect { coin.save }.to raise_error(ActiveRecord::NotNullViolation)
      end

      it "raises error if coin would be created with non-unique pcgs_num" do
        valid_coin.save
        coin_with_nonunique_pcgs_num = Coin.new(valid_coin.attributes.merge(year: 1905, id: 2))

        expect { coin_with_nonunique_pcgs_num.save }.to raise_error(ActiveRecord::RecordNotUnique)
      end

      it "raises error trying to create coin not unique by series, year, mintmark & special_designation" do
        valid_coin.save
        valid_coin_copy = Coin.new(valid_coin.attributes.merge(id: 2, pcgs_num: 1222))

        expect { valid_coin_copy.save }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end

  end
end
