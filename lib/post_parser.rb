require 'nokogiri'

require_relative 'post'
require_relative 'model_finder'

# TODO deal with this
#require_relative '../init'

class PostParser

  class << self

    # parse(post)
    #   parser = self.new(post)
    #   parser.find_price
    #   

    def parse(post)

      # TODO check for despiece

      attributes = {}

      #return {seller: false} if buyer?(post.title)
      return {buyer: true} if buyer?(post.title) # so that dnatables doesn't get undefined

      price = find_price(post.title) || find_price(post.description_no_html)
      attributes[:price] = price

      finder = ModelFinder.new(post.title, post.description)
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

      #brand = find_brand(post.title) || find_brand(post.description_no_html)
      #attributes[:brand] = brand ? brand.first.titleize : nil

      #if brand && brand.size > 1  # TODO refactor this
        #attributes[:model] = brand.last && brand.last.capitalize
      #else
        #attributes[:model] = nil
      #end
      
      # Brand.scan title
      # else scan desc
      #
      # Size.scan title if not desc


      # Get size
      size = find_size(post.title) || find_size(post.description_no_html)
      attributes[:size] = size && size.upcase

      attributes[:frame_only] = contains_cuadro?(post.title) != nil # best way? !!

      attributes[:uri] = post.uri
      attributes[:thread_id] = post.thread_id
      attributes[:name] ||= nil

      #print(post, attributes)
      #if attributes[:brand]
      
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
        # TODO fix: detecting only x without -s or -l
        size_regex = /talla\s([xs,s,m,l,xl])/i
        str.match(size_regex) && str.match(size_regex).captures.first.downcase
        # work with lowercase?
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

      def read_brands
        File.readlines('brand_lists/brand_list.txt')
      end

      def find_price(str)
        # TODO improve algorithm
        #   search for all occurrences of price
        #   detect 'ahora 3000e'
        #   choose most likely price band i.e. 1000e more likely than 150e
        #
        num = /([0-9]?\.?[0-9]{3})/
        price_regex = Regexp.union /[€]#{num}/, /#{num}\s?[€]/, /#{num}\s?eur/i, 
                                   /precio\s?#{num}/, /#{num}e/
        str.match(price_regex) && str.match(price_regex).captures.compact.first.gsub('.', '').to_i
      end

      def print(post, atr)
        puts atr[:price] ? "price found: €#{atr[:price]}" : "no price found"
        puts atr[:brand] ? "brand found: #{atr[:brand]}" : "no brand found: #{post.title}"
        puts "size: #{atr[:size]}" if atr[:size]
        puts "Frame only!!" if contains_cuadro?(post.title)
      end


  end
end

#Post.all.each do |p|
  #puts p.id.to_s + '. ' + p.title
  #PostParser.parse(p)
  #puts '---------------------------'
#end

