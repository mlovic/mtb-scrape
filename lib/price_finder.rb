class PriceFinder

  TYPICAL_RANGE = 800..9000
  TYPICAL_RANGE_FOR_FRAME = 200..2000
  num = /([0-9]?\.?[0-9]{3})/
  NUM_REGEX = num
  PRICE_REGEX    = Regexp.union /[€]#{num}/, /#{num}\s?[€]/, /#{num}\s?eur/i, 
                                /precio\s?#{num}/i, /#{num}e/i
  PRIORITY_REGEX = Regexp.union /la\svendo\spor\s?#{num}/i, 
                                /ahora\s?[a-zA-Z]+\s?#{num}/i,
                                /rebajada\s?\w?#{num}/i,
                                /precio\s?final:?\s*#{num}/i # TODO not catching
                                                             # bike number 1380
                                
                                # TODO ahora [eurosign]2100 wouldn't work
                                #
                                # TODO add 'rebajado a...'
  # precio final:
                                # could also filter by last digit being a 0
                                
  # TODO log how many matches are found

  # sort by
  #   title price, take cheapest
  #   ahora, la vendo por
  #   realistc price
  #   pick out of a range?
                               # sort by
  # def find_price
  #   tokens(title).sort.first  #smallest
  #   # priority here, separately?
  #   tokens = get_tokens(desc)
  #   return first if size == 1
  #   sort_by_realistic(tokens)
  #

  def initialize(title, description, model = nil, frame_only = nil)
    @title = title
    @description = description
    @model = model
    @frame_only = frame_only
    @tokens = []
  end

  def find_price

    # could abstract further to title_tokens || priority_tokens || until one 
    if title_tokens = get_tokens(@title) 
      return title_tokens.sort.first 
    end
    if prior_tokens = get_tokens(@description, priority: true)
      return prior_tokens.sort.last
    end

    tokens = get_tokens(@description)
    return if tokens.nil?
    return tokens.first if tokens&.size == 1
    return filter_by_realistic(tokens).first
  end

  def filter_by_realistic(tokens)
    range = @frame_only ? TYPICAL_RANGE_FOR_FRAME : TYPICAL_RANGE  
    tokens.select { |t| range.include? t.to_i }
  end
 
  def filter_by_credible_values
    range = @frame_only ? TYPICAL_RANGE_FOR_FRAME : TYPICAL_RANGE  
    @tokens.sort! { |t| range.include? t.to_i }
  end

  def get_tokens(str, priority: false)
    regex = priority ? PRIORITY_REGEX : PRICE_REGEX
    tokens = str.scan(regex).flatten.compact.map { |t| t.gsub('.', '') }.map(&:to_i)
    return tokens.present? ? tokens : nil
    # maybe this shouldn't return nil
  end

end
