$:.unshift File.dirname(__FILE__)

require 'pp'
require 'sinatra'
require "sinatra/activerecord"
require 'will_paginate'
require 'will_paginate/active_record'
require "will_paginate-bootstrap"

require 'lib/bike'
require 'lib/brand'
require 'lib/model'
require 'lib/post'

configure :development do
  require 'thin'
  set :server, 'thin'
  set :database, {adapter: "sqlite3", database: "db/foromtb.db"}
  if ENV['START_SCHEDULER'] == true
    require 'fmtb_scheduler'
    FmtbScheduler.start
    ActiveRecord::Base.logger = Logger.new('db/debug.log')
  end
end

configure :production do
  require 'unicorn'
  require 'fmtb_scheduler'
  FmtbScheduler.start
  set :root, File.dirname(__FILE__) 
  set :server, 'unicorn'
  set :database, {adapter: "sqlite3", database: "db/foromtb.db"}
end

helpers do
  def humanize(secs)
    { d: 60*60*24, h: 60*60, m: 60, s: 1 }.each do |k, v|
      next if secs < v
      return "#{(secs / v).to_i} #{k}"
    end
  end
end

get '/' do
  # TODO joins and pluck to reduce num of db calls
  @brands = Brand.confirmed
  @bikes  = Bike.paginate(page: params[:page], per_page: 50)
                .includes(:model, :brand, :post)
                .filter(params)
                .order_by(params[:order])
  #@admin = true unless ENV['RACK_ENV'] == 'production'
  @admin = params['admin']
  erb :index
end

post '/brands/:id/confirm' do |id|
  Brand.find(id).confirmed!
end

delete '/brands/:id' do |id|
  brand = Brand.find(id)
  puts 'Destroying brand ' + brand.name
  brand.destroy
end

get '/models' do
  content_type :json
  if params['brand_id']
    Model.confirmed.where(brand_id: params['brand_id']).select(:id, :name).to_json
  end
end

post '/update-model' do
  # TODO what if bike is not found. Other exception handling
  # or if invalid
  # or no change
  # or name has been taken
  model = Bike.find!(params['bike_id']).model
  puts "Changing model name from #{model.name} to #{params['value']} and confirming"
  model.update!(name: params['value'])
  model.confirmed! # maybe unwise
  params['value']
end

post '/models/:id/confirm' do |id|
  model = Model.find(id)
  model.confirmed!
  model.brand.confirmed!
end

# Not used for now
post '/update-submodel' do
  model = Bike.find(params['bike_id']).model
  model.update(submodel: params['value'])
  model.confirmed!
  params['value']
end

post 'bikes/:id/add-travel' do |id|
  Bike.find(id).model.update!(travel: params['travel']) 
  # TODO show error when invalid
end

# Not used for now
get '/bikes/:thread_id' do |id|
  @post = Post.find_by(thread_id: id.to_i)
  erb :show
end

# Not used
get '/data' do
  content_type :json
  @posts = Post.all
  puts 'retrieved posts'
  @posts = @posts.map do |p|
    PostParser.get_bike_attributes(p) # nil for buyers
  end
  puts 'parsed posts'
  #pp @posts
  @posts = @posts.compact.to_json.gsub('null', '""') # TODO fix hack, move to js?
end
