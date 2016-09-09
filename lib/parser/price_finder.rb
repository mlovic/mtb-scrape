class PriceFinder
  # TODO log data on how prices are found to find patterns

  TYPICAL_RANGE = 700..9000
  TYPICAL_RANGE_FOR_FRAME = 200..2000
  num = /([0-9]?\.?[0-9]{3})/
  NUM_REGEX = num
  PRICE_REGEX    = Regexp.union /precio:?\s?#{num}/i, /[€]#{num}/, 
                                /#{num}\s?[€]/, /#{num}\s?eur/i, 
                                /#{num}e/i
  PRIORITY_REGEX = Regexp.union /la\svendo\spor\s?[€]?#{num}/i, 
                                /ahora\s?[a-zA-Z]*\s?[€]?#{num}/i,
                                /rebaj[a-zA-Z]+\s?a?\s?[€]?#{num}/i, # only 'a'?
                                /precio\s?final:?\s*[€]?#{num}/i, # TODO not catching
                                /nuevo\sprecio:?\s*[€]?#{num}/i,
                                /precio\snuevo:?\s*[€]?#{num}/i
                                
  def initialize(title, description, model = nil, frame_only = nil)
    @title = title
    @description = description
    @model = model
    @frame_only = frame_only
  end

  # Could also filter by last digit being a 0
  # Rank regexes individually by priority?
  # Prefer lowest or last?
  def find_price
    possible_prices = 
      get_tokens(@title,       priority: true) ||
      get_tokens(@title,       priority: false) ||
      get_tokens(@description, priority: true) ||
      get_tokens(@description, priority: false)

    return unless possible_prices

    filter_by_realistic(possible_prices)&.sort&.first
  end

  def filter_by_realistic(tokens)
    range = @frame_only ? TYPICAL_RANGE_FOR_FRAME : TYPICAL_RANGE  
    tokens.select { |t| range.include? t.to_i }.sort
  end

  def get_tokens(str, priority: false)
    regex = priority ? PRIORITY_REGEX : PRICE_REGEX
    tokens = str.scan(regex).flatten.compact.map { |t| t.gsub('.', '') }.map(&:to_i)
    return !tokens.empty? ? tokens : nil
    # maybe this shouldn't return nil
  end

end
