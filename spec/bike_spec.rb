require_relative 'spec_helper'
require_relative 'factories'

require_relative '../lib/bike'
require_relative '../lib/brand'
require_relative '../lib/post'

require 'will_paginate'
require 'will_paginate/active_record'

RSpec.describe Bike do
  let(:post) { Post.create(fixture('post.yml')) }
  #let(:bike) { Bike.new(fixture('bike.yml')) }
  let(:bike) { build(:bike) }

  it 'model' do
    p build(:model)
    p build(:model, brand_name: 'One')
  end

  describe '.order_by' do
    # TODO

    it 'rejects unsupported orders' do
      expect { Bike.order_by('nil') }.to_not raise_error
    end 
  end

  describe '.filter' do
    before do
      create(:bike, price: 1000, model: create(:model, travel: 120))
      create(:bike, price: 1500, model: create(:model, travel: 160))
      create(:bike, price: 2000, model: create(:model, travel: 180))
    end

    it 'with paginate' do
      params = { 'min_travel' => '160', 'max_travel' => '170' }

      bikes = Bike.paginate(page: params[:page], per_page: 2).joins(:model)
      bikes = bikes.filter(params).ordered_by_last_message
      expect(bikes.size).to eq 1
    end

    it 'with prices' do
      params = { 'min_price' => '1200', 'max_price' => '1700' }
      bikes = Bike.filter(params)
      expect(bikes.size).to eq 1
    end

    it 'returns fraction of results' do
      params = { 'min_travel' => '160', 'max_travel' => '170' }
      bikes = Bike.filter(params)
      expect(bikes.size).to eq 1
    end

    it 'params can be nil' do
      params = { 'min_travel' => 160, 'max_travel' => ''}
      bikes = Bike.filter(params)
      expect(bikes.size).to eq 2
    end
  end

  it 'with traits' do
    p build(:bike, :with_names, brand_name: 'Mondraker', model_name: 'Foxy')
  end

  it 'factory' do
    bike = build(:bike, :with_names, brand_name: 'Mondraker', model_name: 'Foxy')
    expect(bike.save).to eq true
  end

  it 'delegates post methods to post' do
    bike.post = post
    expect(bike.title).to eq "USADO (REBAJADO)CUADRO MONDRAKER FOXY RR+TALAS 36 RC2"
  end

  it 'orders by last_message time by default' do
    #new_bike = Bike.new(fixture('bike.yml')) 
    new_post = build(:post, thread_id: 1234)
    new_post.last_message_at = Time.now
    new_post.save!
    new_bike = build(:bike, price: 1800, post: new_post)
    #bike.post = post
    bike.save!
    new_bike.save!
    #p Bike.joins(:post).first.last_message_at
    expect(Bike.all.map(&:id)).to eq [1, 2]
    expect(Bike.ordered_by_last_message.map(&:id)).to eq [2, 1]
  end

  it 'same' do
    pending
    bike.post  = post
    bike.brand = Brand.create(name: 'Mondraker')
    bike.save!
    new_bike = Bike.new(fixture('bike.yml'))
    new_bike.post = post
    new_bike.brand = Brand.take
    expect(bike.attributes).to eq new_bike.attributes
  end

end
