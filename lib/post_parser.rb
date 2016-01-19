require 'nokogiri'

require_relative 'post'
require_relative 'model_finder'
require_relative 'price_finder'

class PostParser

  class << self

    def parse(post)

      # TODO check for despiece

      attributes = {}

      return {buyer: true} if buyer?(post.title) # so that dnatables doesn't get undefined

      attributes[:frame_only] = !!contains_cuadro?(post.title) 
      
      finder = ModelFinder.new(post.title, post.description)
      # TODO should be desc without html
      attributes[:brand_id] = finder.get_brand && finder.get_brand.id
      model = finder.get_model
      if model.class == String
        #attributes[:model_name] = finder.get_model
        #goes up without model_id or name. it'll use the post.title
        # fix this
      elsif model.class == Model 
        attributes[:model_id] = finder.get_model.id
      else
        attributes[:model_id] = nil
      end

      pfinder = PriceFinder.new(post.title, post.description, model, attributes[:frame_only])
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

    #def parse(post)
      #return nil if Bike.find_by(post_id: post.id)
      #attributes = get_bike_attributes(post)
      #bike = Bike.new(price: attributes[:price], 
                      #frame_only: attributes[:frame_only],
                      #size: attributes[:size],
                      #brand: Brand.find_by(name: attributes[:brand])
                     #)
      #bike.save!
      #p bike
      #return attributes
    #end

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

      def find_brand(str)
        # TODO must be single word
        #brands = read_brands.map(&:strip)
        # TODO find better way
        # maybe use detect, but have to deal with capting models too
        brands = Brand.confirmed.map(&:name)
        #brands = Brand.all.map(&:name)
        brands.each do |b|
          # TODO make words following brand optional in regex!! 
          #   'Vendo Giant' doesn't match
          return str.match(/(#{b})\s(\w+)?/i).captures if str.match(/(#{b})\s(\w+)?/i)
          # TODO match only word. Currently matching ks from sworks
          # above doesn't take dash as an acceptable word character
        end

        brands = Brand.unconfirmed.map(&:name)
        brands.each do |b|
          return str.match(/(#{b})\s(\w+)?/i).captures if str.match(/(#{b})\s(\w+)?/i)
        end

        nil
      end

      def print(post, atr)
        puts atr[:price] ? "price found: €#{atr[:price]}" : "no price found"
        puts atr[:brand] ? "brand found: #{atr[:brand]}" : "no brand found: #{post.title}"
        puts "size: #{atr[:size]}" if atr[:size]
        puts "Frame only!!" if contains_cuadro?(post.title)
      end

  end
end
