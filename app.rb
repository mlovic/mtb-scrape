$:.unshift File.dirname(__FILE__)

require 'sinatra'
require 'pp'
require "sinatra/activerecord"
require 'will_paginate'
require 'will_paginate/active_record'  # or data_mapper/sequel
require "will_paginate-bootstrap"

require 'lib/bike'
require 'lib/brand'
require 'lib/model'
require 'lib/post'

p ENV['RACK_ENV']

configure :development do
  require 'thin'
  set :server, 'thin'
  set :database, {adapter: "sqlite3", database: "db/foromtb.db"}
  #ActiveRecord::Base.logger = Logger.new('db/debug.log')
end

configure :production do
  set :root, File.dirname(__FILE__) 
  require 'unicorn'
  set :server, 'unicorn'
  set :database, {adapter: "sqlite3", database: "db/foromtb.db"}
end
#pp ENV

helpers do
  def word_after_brand(bike)
    brand_name, str = bike.brand_name, bike.title # move outside of helper?
    brand_name ? str.split(/#{brand_name}/i).last.split(' ').first.to_s : nil
  end

  def humanize(secs)
    { d: 60*60*24, h: 60*60, m: 60, s: 1 }.each do |k, v|
      next if secs < v
      return "#{(secs / v).to_i} #{k}"
    end
  end

end

# actually fix this at some point
before do
  p params
end

after do
  ActiveRecord::Base.clear_active_connections!
end 

get '/' do
  #does params automatically split string into array?
  #params[:min_travel] ||= 0 if params[:min_travel] == ''
  #params[:max_travel] ||= 230 if  params[:max_travel] == ''
  #params[:min_price] ||= 0 if params[:min_price] == ''
  #params[:max_price] ||= 12000 if params[:max_price] == ''
  @bikes = Bike.paginate(page: params[:page], per_page: 50).joins(:model)
  #@bikes = @bikes.where(models: { 'travel > ?' => params[:min_travel] }) if params[:min_travel]
  #@bikes = @bikes.where(models: { 'travel < ?' => params[:max_travel] }) if params[:max_travel]
  @bikes = @bikes.where('models.travel > ?', params[:min_travel] ) unless params[:min_travel].blank?
  @bikes = @bikes.where('models.travel < ?', params[:max_travel] ) unless params[:max_travel].blank?
  @bikes = @bikes.where('price > ?', params[:min_price])           unless params[:min_price].blank?
  @bikes = @bikes.where('price < ?', params[:max_price])           unless params[:max_price].blank?
  @bikes = @bikes.where(size: params[:sizes])                      unless params[:sizes].blank?
  @bikes = @bikes.ordered_by_last_message
  erb :index
end

post '/add-travel/:id' do
  Bike.find(params['id']).model.update!(travel: params['travel'])
  # error unless if travel.valid?
end

post '/confirm-brand' do
  Brand.find(params['id']).confirmed!
  # take away and put into mtbscrape
end

post '/delete-brand' do
  brand = Brand.find(params['id'])
  puts 'Destroying brand ' + brand.name
  brand.destroy
end

post '/update-model' do
  # TODO what if bike is not found. Other exception handling
  # or if invalid
  # or no change
  # or name has been taken
  model = Bike.find(params['bike_id']).model
  model.update(name: params['value'])
  model.confirmed! # maybe unwise
  params['value']
end

post '/update-submodel' do
  model = Bike.find(params['bike_id']).model
  model.update(submodel: params['value'])
  model.confirmed!
  params['value']
end

post '/confirm-model' do
  #bike = Bike.find(params['bike_id'])
  Model.find(params['id']).confirmed!
  # confirm bike as well?
  #
  #model = Model.create!(name: params['model_name'].titleize, 
                        #brand_id: bike.brand.id)
  #bike.model = model
  # update other bikes with same model name
  # i think we should follow same confirmation_status system as with brands
  #bike.!save
end

get '/bikes/:thread_id' do |id|
  p id.class
  @post = Post.where(thread_id: id.to_i).take
  erb :show
end

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
  @posts
end
