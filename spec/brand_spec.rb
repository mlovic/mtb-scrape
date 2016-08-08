require_relative 'spec_helper'

RSpec.describe Brand do
  let!(:brand) { Brand.create name: 'Mondraker' }
  it "can't be destroyed" do
    #brand = Brand.create(name: 'Mondraker')
    expect { brand.destroy }.to raise_error 'testtt' #ActiveRecord::ReadOnlyRecord
  end
  #let!(:brand) { Brand.create name: 'Mondraker' }
  it 'should have a unique name' do
    invalid_brand = Brand.create(name: 'Mondraker')
    expect(invalid_brand.save).to be false
  end
  describe 'confirmation status' do
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
