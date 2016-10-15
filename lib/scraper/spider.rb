require_relative '../logging'

class Spider

  include Logging

  def initialize(agent, time_between_requests: 2)
    @agent = agent
    @waiting_for_response = false
    @wait_time = time_between_requests
  end
  
  def kill
    @thread&.kill
  end

  # TODO why mechanize? Switch to Net::HTTP + Nokogiri?
  # TODO no reason for spider to know about handler
  def crawl_async(in_queue, out_queue)
    @thread = Thread.new do
                until in_queue.closed?
                  (url, handler = in_queue.pop) or Thread.exit
                  @waiting_for_response = true
                  logger.debug "Fetching #{url}..."
                  begin
                    page = @agent.get(url)
                  rescue StandardError => e
                    logger.error "An Error occurred while requesting #{url}:"
                    logger.error e.message
                    logger.error e.backtrace
                    next
                  end
                  #check_status(page)
                  @waiting_for_response = false
                  #puts "Done fetching #{url}"
                  out_queue.push [page, handler]
                  sleep @wait_time # sleep variable amount of time depending on request time?
                end
              end
  end

  def check_status(page)
    unless page.code =~ /2[0-9]{2}/
      logger.error "HTTP #{} Request not successftul"
    end
  end
  
  def waiting_for_response?
    @waiting_for_response
  end
end
