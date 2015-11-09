require 'mechanize'

#uri = "https://bikeindex.org/manufacturers"

#agent = Mechanize.new
#page = agent.get uri
#puts 'retrieved page'

page = Nokogiri::HTML(File.open('manufacturers'))

names = page.css('td')

File.open('brand_list.txt', 'w') do |f|
  names.each_with_index do |n, i|
    if i % 3 == 0
      f.puts n.text.strip
    end
  end
end

