class ModelFinder

  def initialize(title, description)
    @title = title
    @description = description
  end

  def get_brand
    #brand_regex = /(#{b})\s(\w+)?/i make this a private func?
    #brands = Brand.all.map(&:name)
      # TODO make words following brand optional in regex!! 
      #   'Vendo Giant' doesn't match  - space char not optional i think
      # TODO match only word. Currently matching ks from sworks
      # above doesn't take dash as an acceptable word character
    
    return search_for_brand
    
  end

  def get_model
    search_for_brand unless @after_brand_text && @brand
    @after_brand_text or return nil
    possible_name = @after_brand_text.split(' ').first.titleize 
    # TODO accepting blank i think
    # TODO Confirmed first!
    # use below first_or_create
    Model.where(brand_id: @brand.id, name: possible_name).take ||
      Model.create!(brand_id: @brand.id, name: possible_name)
  end

  def search_for_brand
    #return @search_results if @search_results

    [@title, @description].each do |str| # consider using any num of texts
      [:confirmed, :unconfirmed].each do |status|

        Brand.send(status).each do |b| # use find here
          if match = str.match(/\b#{b.name}\b/i)
            # improve this
            @after_brand_text = str.split(match.to_s).last.strip
            @brand = b
            return b
          end
        end

      end
    end
    nil
  end

end
