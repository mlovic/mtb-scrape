#require_relative 'spec_helper'
#require 'benchmark'

#require 'concurrent'
#require 'thread'

## Multi-threading causing VCR errors

#VCR.configure do |c|
  #c.allow_http_connections_when_no_cassette = true
#end

#class Ticker
  #def update(time, value, reason)
    ##puts time
    ##puts value
  #end
#end

#RSpec.describe 'async' do
  #let(:agent) { agent = Mechanize.new }
  #let(:ticker) { Ticker.new }
  #let(:url) { "https://github.com/ruby-concurrency/concurrent-ruby" }

  #it 'sequential' do
    #pending

    #sleep 20

    #time = Benchmark.measure do
      #5.times { agent.get url }
    #end

    #puts "agent.get: " + time.to_s
  #end

  #it 'async' do
    #pending
    #time = Benchmark.measure do
      ##5.times { agent.get ForoMtb::FOROMTB_URI }
      #ary = []
      #50.times do
        #future = Concurrent::Future.new  { agent.get url }
        #future.add_observer(ticker)
        #future.execute
        #ary << future
      #end
      #ary.each { |f| f.value }

    #end
    #puts "agent.get: " + time.to_s
  #end

#end


