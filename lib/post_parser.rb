require 'nokogiri'

require_relative 'post'
require_relative 'model_finder'
require_relative 'price_finder'

class PostParser

  class << self

    def parse(post)

      # TODO check for despiece
      # TODO check for vendida

      # TODO wheel size
      attributes = {}

      return {buyer: true} if buyer?(post.title) # so that dnatables doesn't get undefined

      attributes[:frame_only] = !!contains_cuadro?(post.title) 
      
      finder = ModelFinder.new(post.title, post.description_no_html)
      attributes[:brand_id] = finder.get_brand&.id 
      attributes[:model_id] = finder.get_model&.id

      model = attributes[:model_id]

      pfinder = PriceFinder.new(post.title, post.description_no_html, model, attributes[:frame_only])
      attributes[:price] = pfinder.find_price


      # Get size
      size = find_size(post.title) || find_size(post.description_no_html)
      attributes[:size] = size && size.upcase


      attributes[:uri] = post.uri
      attributes[:thread_id] = post.thread_id
      attributes[:name] ||= nil

      #print(post, attributes)
      
      return attributes
    end
    alias_method :get_post_attributes, :parse

    private

      def buyer?(str)
        str.match(/compro/i) || str.match(/busco/i)
      end

      def contains_cuadro?(str)
        # search also in desc? Maybe use price to decide as well
        # also check for 'cuadro o bici complete'
        str.match(/cuadro/i)
      end

      def find_size(str)
        size_regex = /talla\s((xs|s|m|l|xl))/i
        str.match(size_regex) && str.match(size_regex).captures.first.downcase
      end

      def print(post, atr)
        puts atr[:price] ? "price found: €#{atr[:price]}" : "no price found"
        puts atr[:brand] ? "brand found: #{atr[:brand]}" : "no brand found: #{post.title}"
        puts "size: #{atr[:size]}" if atr[:size]
        puts "Frame only!!" if contains_cuadro?(post.title)
      end

  end
end
