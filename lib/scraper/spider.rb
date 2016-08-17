class Spider

  def initialize(agent, time_between_requests: 2)
    @agent = agent
    @waiting_for_response = false
    @wait_time = time_between_requests
  end
  
  def crawl_async(in_queue, out_queue)
    # TODO why mechanize? Switch to Net::HTTP?
    # TODO error handling - check status, etc.
      @thread = Thread.new do
                  until in_queue.closed?
                    # TODO no reason for spider to know about handler
                    (url, handler = in_queue.pop) or Thread.exit
                    @waiting_for_response = true
                    puts "Fetching #{url}..."
                    page = @agent.get(url)
                    #raise NetworkError unless page.code.match(/^2/)
                    @waiting_for_response = false
                    #puts "Done fetching #{url}"
                    out_queue.push [page, handler]
                    sleep @wait_time # sleep variable amount of time depending on request time?
                  end
                end
  end
  
  def waiting_for_response?
    @waiting_for_response
  end
end
