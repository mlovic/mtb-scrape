require 'thor'
require 'pp'

$LOAD_PATH << '.'

require 'mtb_scrape'

#module MtbScrape 
  class MtbCli < Thor
    package_name "Mtb"

    desc 'scrape NUM_PAGES', 'scrapes N number of pages from foromtb'
    def scrape(num_pages)
      MtbScrape::fmtb_scrape(num_pages.to_i)
    end

    desc 'parse_posts', 'parses all posts in db and saves them in bikes table'
    def parse_posts
      Post.all.each do |post| 
        next if Bike.exists?(post_id: post.id)
        puts 'parsing  ' + post.title + '  - ' + post.id.to_s
        attributes = PostParser.parse(post)
        next if attributes[:buyer]
        bike = Bike.new(price: attributes[:price], 
                        frame_only: attributes[:frame_only],
                        size: attributes[:size],
                        brand_id: attributes[:brand_id],
                        model_id: attributes[:model_id],
                        post_id: post.id
                       )
        bike.save!
      end
      # posts.each
      #   attrs = parse_post
      #   bikes.new attrs if bikes doesnt exist
      #
      #   with logging
      #
      #
      #
      #
      #
    end

  end
#end
