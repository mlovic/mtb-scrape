class Processor
  def initialize(queue, *handlers)
    @queue    = queue # does nothing with 2nd, alternative impl
    @handlers = handlers
  end

  def match_handler(handler)
    @handlers.find { |h| h.class == handler }
  end

  def dispatch(page, handler)
    target = match_handler(handler) or raise "Unknown handler! #{handler}"
    target.process_page(page)
  end

  def start
    until @queue.empty?
      #if page_and_handler = @queue.pop
        #page, handler = page_and_handler
      page, handler = @queue.pop
      target = match_handler(handler) or raise "Unknown handler! #{handler}"
      target.process_page(page)
    end
  end
end
