require_relative 'spec_helper'

RSpec.describe Brand do
  #it "can't be destroyed" do
    #brand = Brand.create(name: 'Mondraker')
    #expect { brand.destroy }.to raise_error ActiveRecord::ReadOnlyRecord
  #end
  describe 'confirmation status' do
    let!(:brand) { Brand.create name: 'Mondraker' }
    it 'is unconfirmed by default' do
      expect(brand.confirmed?).to be false
      expect(brand.confirmation_status).to eq 'unconfirmed'
    end

    it 'can be confirmed' do
      brand.confirmed!
      expect(brand.confirmed?).to be true
    end
  end
end
