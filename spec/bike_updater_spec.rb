require_relative 'spec_helper'
require_relative '../lib/bike_updater'
require_relative '../lib/bike'
#require_relative '../lib/brand'
require_relative '../lib/post'
require_relative 'factories'

RSpec.describe 'Bike update feature' do
  #BikeUpdater.update
end

RSpec.describe BikeUpdater do
  before do
    @bike = create(:bike, :with_names, size: nil, brand_name: 'Mondraker', model_name: 'Foxy')
    create(:brand, name: 'Specialized', confirmation_status: 1)
    Post.first.update(title: 'Specialized bighit M a 1200e!!')
    #ActiveRecord::Base.logger = Logger.new(STDOUT)
    @updater = BikeUpdater.new
    allow(@updater).to receive(:report)
  end

  it '.update_bike' do
    @updater.update_bike(@bike.reload)
    expect(Bike.first.brand_name).to eq 'Specialized'
  end

  it '.update_bikes' do
    @updater.update_bikes

    expect(Bike.first.brand_name).to eq 'Specialized'
  end

  it 'dry run' do
    @updater.update_bikes(dry_run: true)

    expect(Bike.first.brand_name).to eq 'Mondraker'
  end

  it 'single bike' do
    @updater.update_bikes(id: 1, dry_run: false)

    expect(Bike.first.brand_name).to eq 'Specialized'
  end
end
