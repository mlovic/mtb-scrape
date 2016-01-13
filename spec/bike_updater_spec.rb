require_relative 'spec_helper'

RSpec.describe 'Bike update feature' do
  #BikeUpdater.update
end

RSpec.describe BikeUpdater do
  before do
    create(:bike, :with_names, size: nil, brand_name: 'Mondraker', model_name: 'Foxy')
    create(:brand, name: 'Specialized', confirmation_status: 1)
    Post.first.update(title: 'Specialized bighit M a 1200e!!')
    #ActiveRecord::Base.logger = Logger.new(STDOUT)
    @updater = BikeUpdater.new
    allow(@updater).to receive(:report)
  end
  it '.update' do
    @updater.update_bikes

    expect(Bike.first.brand_name).to eq 'Specialized'
  end

  it 'dry run' do
    @updater.update_bikes(dry_run: true)

    expect(Bike.first.brand_name).to eq 'Mondraker'
  end
end
