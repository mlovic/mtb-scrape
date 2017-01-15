$:.unshift File.dirname(__FILE__)
require 'mechanize'

def google(model_name, brand_name = nil)
  agent = Mechanize.new
  agent.user_agent_alias = 'Mac Safari'
  agent.get("https://www.google.es/search?q=travel+#{brand_name}+#{model_name}")
end

def extract(page)
  sts = page.root.css('.st')
  sts.map { |st| st.to_s.scan(/([0-9]{3}).{0,2}mm/) }.flatten
end

def mode(list)
  freq = list.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
  list.max_by { |v| freq[v] }
end

def google_travel(model, brand=nil)
  page = google(model, brand)
  extract(page)
end


require 'mtb_scrape'
require 'init'

models_by_most_common = Model.all.sort_by { |m| m.bikes.count }.reverse

models_by_most_common.each do |m| 
  next if m.travel
  next unless m.brand
  results = google_travel(m.name, m.brand.name) 
  puts "Found #{results}"
  next if results.empty?
  travel = mode(results).to_i
  puts "Updating travel of #{m.brand.name} #{m.name} to #{travel}"
  m.update(travel: travel) 
  sleep(60 + (rand 30))
end
