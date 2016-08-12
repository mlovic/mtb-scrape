require 'nokogiri'

require_relative 'post'
require_relative 'parser/model_finder'
require_relative 'parser/price_finder'

class PostParser

  class << self

    def parse(post)
      # TODO add inches to size
      # TODO check for despiece
      # TODO check for retirad@ / se retira / retiro la bici / comprado
      # TODO check for cambio?
      # # TODO maybe mark as solid, good example or shakey (cambio, cerrado, vendida (without rest of title), etc)
      # for stats purposes. Maybe also take into account how sure, like if 
      # info was found in title or multiple prices were found
      # TODO wheel size
      #
      # TODO what if they update only desc. Like make a discount. Reparse periodically?
      # TODO follow posts
      return {buyer: true} if buyer?(post.title) # so that dnatables doesn't get undefined
      attributes = get_basic_attributes(post)

      finder = ModelFinder.new(post.title, post.description_no_html)
      attributes[:brand_id] = finder.get_brand&.id 
      attributes[:model_id] = finder.get_model&.id

      pfinder = PriceFinder.new(post.title, post.description_no_html, attributes[:frame_only])
      attributes[:price] = pfinder.find_price
      
      return attributes
    end

    def get_basic_attributes(post)
      attributes = {}
      size = find_size(post.title) || find_size(post.description_no_html)
      attributes[:size] = size && size.upcase
      attributes[:frame_only] = !!contains_cuadro?(post.title) 
      attributes[:is_sold] = sold?(post.title)
      return attributes
    end

    alias_method :get_post_attributes, :parse

    private

      def sold?(str)
        !!str.match(/vendid/i)
      end

      def buyer?(str)
        str.match(/compro/i) || str.match(/busco/i)
      end

      def contains_cuadro?(str)
        # search also in desc? Maybe use price to decide as well
        # also check for 'cuadro o bici complete'
        str.match(/cuadro/i)
      end

      def find_size(str)
        letter = "(xs|s|m|l|xl)"
        size_regex = Regexp.union /talla\s#{letter}/i, /t\s?-\s?#{letter}/i,
                                  /\(#{letter}\)/i
        if match = str.match(size_regex) 
          match.captures.compact.first.downcase
        end
      end

      def print(post, atr)
        puts atr[:price] ? "price found: €#{atr[:price]}" : "no price found"
        puts atr[:brand] ? "brand found: #{atr[:brand]}" : "no brand found: #{post.title}"
        puts "size: #{atr[:size]}" if atr[:size]
        puts "Frame only!!" if contains_cuadro?(post.title)
      end

  end
end
