require 'bunny'
require 'json'

require 'lib/post_parser'
require 'lib/bike'
require 'lib/bike_update'

# start RMQ connection
# get right q from RMQ
# start thread to sub to q
# eval message properties 
# parse, build bike and save in db
# log/handle errors

conn = Bunny.new(ENV['RMQ'])
begin
  puts "Connecting to RabbitMQ..."
  conn.start
rescue StandardError => e
  puts "Failed to connect to RabbitMQ"
  puts e.message
  sleep 1
  retry
end

conn.start
ch  = conn.create_channel
x   = ch.fanout("posts")
q   = ch.queue("", :exclusive => true)
q.bind(x)
 
q.subscribe(block: false) do |delivery_info, properties, body|
  payload = JSON.parse(body)
  if properties.type == 'create'
    logger.debug "Parsing " + post.title
    attributes = PostParser.parse(post)
    bike = Bike.new(attributes)
    bike.post = post
    bike.save!
  elsif properties.type == 'update'
    BikeUpdater.update(post.bike)
  else
    logger.error "Unknown message type: \n"\
                 "Delivery info: #{delivery_info}\n"\
                 "Properties: #{properties}\n"\
                 "Body: #{body}"
  end
end
