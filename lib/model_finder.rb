class ModelFinder

  def initialize(title, description)
    @title = title
    @description = description
  end

    #brand_regex = /(#{b})\s(\w+)?/i make this a private func?
      #   'Vendo Giant' doesn't match  - space char not optional i think
      # TODO match only word. Currently matching ks from sworks
      # above doesn't take dash as an acceptable word character
  
  def get_brand
    # TODO how about throw/catch here
    @brand = scan_for_brand(@title, :confirmed) ||
             # scan_for_model(@title, :confirmed)&.brand
             scan_for_brand(@description, :confirmed) ||
             scan_for_brand(@title, :unconfirmed) ||
             scan_for_brand(@description, :unconfirmed)
    # consider using any num of texts
  end

  def scan_for_brand(str, status = :all)
    #[:confirmed, :unconfirmed].each do |status|
    Brand.send(status).find do |b| # use find here
      if match = str.match(/\b#{b.name.gsub(' ', "\s?")}\b/i)
        @brand_context = str.split(match.to_s, 2).last
        # TODO tolerate space in brand name. same for model
        #   gsub space for \s? on interpolation?
        # also ignore c from commencal
      end
    end
  end

  def scan_for_model(str, status = nil, brand_id: nil)
    models = filter_models(status, brand_id)
    models.find do |m| # use find here
      # TODO remove tildes
      # # TODO blacklist?
      str.match(/\b#{m.name}\b/i)
        #throw :found_model
      # here i could directly end. throw model
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
      if model = scan_for_model(@brand_context, :confirmed, brand_id: @brand.id) || 
                 scan_for_model(@brand_context, :unconfirmed, brand_id: @brand.id)
        return model
      else
        guess_model(@brand_context)
      end
    else
      scan_for_model(@title, :confirmed) ||
      scan_for_model(@description, :confirmed)
      scan_for_model(@title, :unconfirmed) ||
      scan_for_model(@description, :unconfirmed)
    end
  end

  # TODO blacklist: precio, doble, years, wheel size
  def guess_model(str)
    possible_name = /(\w{3,14})/
    match = str.strip.match(/^#{possible_name}\b/)
    if match
      model_name = match.captures.first.to_s.downcase.capitalize
      Model.create!(brand_id: @brand.id, name: model_name)
    end
  end

  #rescue ActiveRecord::RecordInvalid => invalid
    #p invalid
    #p invalid.record
    #puts invalid.record.errors

    #[@title, @description].each do |str| # consider using any num of texts
      #[:confirmed, :unconfirmed].each do |status|


end
