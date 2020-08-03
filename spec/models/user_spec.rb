require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'validation tests' do 
    it 'ensures name presence' do
      user = User.new(name: "", password: "my password")
      
      expect(user.save).to eq(false)
    end

    it 'ensures password presence' do
      user = User.new(name: "My Name")
      
      expect(user.save).to eq(false)
    end

    it "ensures password length >= 8" do
      user = User.new(name: "My Name", password: "7letter")

      expect(user.save).to eq(false)
    end

    it 'allows user to be created with a username and valid password' do
      user = User.new(name: "My Name", password: "8letters")

      expect(user.save).to eq(true)
    end
  end

end
