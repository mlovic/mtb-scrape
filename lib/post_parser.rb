require 'nokogiri'

require_relative 'post'

# TODO deal with this
require_relative '../init'

class PostParser

  class << self

    def parse(post)

      attributes = {}

      return {seller: false} if buyer?(post.title)

      price = find_price(post.title) || find_price(post.description_no_html)
      attributes[:price] = price

      brand = find_brand(post.title)
      attributes[:brand] = brand.first if brand
      attributes[:model] = brand.last if brand && brand.size > 1

      # Get size
      size = find_size(post.title) || find_size(post.description_no_html)
      attributes[:size] = size

      attributes[:frame_only] = contains_cuadro?(post.title) != nil # best way?

      #print(post, attributes)
      return attributes
    end

    private

      def print(post, atr)
        puts atr[:price] ? "price found: €#{atr[:price]}" : "no price found"
        puts atr[:brand] ? "brand found: #{atr[:brand]}" : "no brand found: #{post.title}"
        puts "size: #{atr[:size]}" if atr[:size]
        puts "Frame only!!" if contains_cuadro?(post.title)
      end

      def buyer?(str)
        str.match(/compro/i) || str.match(/busco/i)
      end
      def contains_cuadro?(str)
        # search also in desc? Maybe use price to decide as well
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
        brands = read_brands.map(&:strip)
        # TODO find better way
        brands.each do |b|
          return str.match(/(#{b})\s(\w+)?/i).captures if str.match(/(#{b})\s(\w+)?/i)
          # above doesn't take dash as an acceptable word character
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
  end
end

#Post.all.each do |p|
  #puts p.id.to_s + '. ' + p.title
  #PostParser.parse(p)
  #puts '---------------------------'
#end

#post = Post.find(32)
#puts post.description_no_html
#PostParser.parse post
