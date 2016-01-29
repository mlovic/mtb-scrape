class ModelFinder

  def initialize(title, description)
    @title = title
    @description = description
  end

    #brand_regex = /(#{b})\s(\w+)?/i make this a private func?
    #brands = Brand.all.map(&:name)
      # TODO make words following brand optional in regex!! 
      #   'Vendo Giant' doesn't match  - space char not optional i think
      # TODO match only word. Currently matching ks from sworks
      # above doesn't take dash as an acceptable word character
  
  def get_brand
    @brand = scan_for_brand(@title, :confirmed) ||
             scan_for_brand(@description, :confirmed) ||
             scan_for_brand(@title, :unconfirmed) ||
             scan_for_brand(@description, :unconfirmed)
    # consider using any num of texts
  end

  def scan_for_brand(str, status = :all)
    #[:confirmed, :unconfirmed].each do |status|
    Brand.send(status).find do |b| # use find here
      if match = str.match(/\b#{b.name}\b/i)
        @brand_context = str.split(match.to_s, 2).last
        #p @brand_context
      end
        #@after_brand_text = str.split(match.to_s).last.strip
    end
  end

  def scan_for_model(str, status = nil, brand_id: nil)
    models = filter_models(status, brand_id)
    models.find do |m| # use find here
      #p m.name
      str.match(/\b#{m.name}\b/i)
    end
  end

  def filter_models(status, brand_id)
    models = status ? Model.send(status) : Model.where(nil)
    models = models.where(brand_id: brand_id) if brand_id
    models
  end
  # Find confirmed brand
  # If found
  #   filter models by brand and scan for those
  #   if found
  #     return
  #   else
  #     scan for all models
  # else
  #   scan for all confirmed models

  def get_model
    @brand ||= get_brand
    if @brand
      models = @brand.models
      if model = scan_for_model(@brand_context, :confirmed, brand_id: @brand.id) || 
                 scan_for_model(@brand_context, :unconfirmed, brand_id: @brand.id)
        return model
      else
        guess_model(@brand_context)
      end
    end
  end

  def guess_model(str)
    match = str.strip.match(/^(\w+)\b/)
    if match
      model_name = match.captures.first.to_s.titleize
      Model.create!(brand_id: @brand.id, name: model_name)
    end
  end

  def elses
    search_for_brand unless @after_brand_text && @brand
    @after_brand_text or return nil
    possible_name = @after_brand_text.split(' ').first.titleize 
    # TODO change to below. It breaks right now
    #possible_name = @after_brand_text.split(/[\s+\/]/).first.titleize 
    # TODO improve above. accepting .com right now
    # TODO accepting blank i think
    # TODO Confirmed first!
    # use below first_or_create
    Model.where(brand_id: @brand.id, name: possible_name).take ||
      Model.create!(brand_id: @brand.id, name: possible_name)
  rescue ActiveRecord::RecordInvalid => invalid
    p invalid
    p invalid.record
    puts invalid.record.errors
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
