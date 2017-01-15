require 'rack'
require 'rack/test'
require_relative 'spec_helper'
require_relative 'helpers'

ENV['RACK_ENV'] = 'test'
require_relative '../app'

RSpec.describe 'Integration test: analyze post from RabbitMQ' do
  include Rack::Test::Methods
  include Helpers

  def app() Application end

  before do
    conn = Bunny.new(ENV['RMQ'])
    conn.start
    ch = conn.create_channel
    @exchange = ch.fanout("posts")
    Model.create name: 'Foxy', brand_id: 1, confirmation_status: 'confirmed' 
    Brand.create name: 'Mondraker', confirmation_status: 'confirmed' 
  end

  it 'builds bikes from new posts' do
    @exchange.publish(build(:post).as_json)
    wait_until { Bike.count == 1 }
    expect(Bike.count).to eq 1
    expect(Bike.brand.name).to eq 'Mondraker'
    expect(Bike.model.name).to eq 'Foxy'
  end

end
