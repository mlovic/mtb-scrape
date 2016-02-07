require 'rufus-scheduler'

module FmtbScheduler
  def self.start
    scheduler = Rufus::Scheduler.new
    scheduler.every '5m', first: :now do
      MtbScrape.fmtb_scrape(1)
      MtbScrape.parse_virgin_posts
      # TODO change name, why is it virgin???
    end
    # TODO do a more thorough check/scrape every longer time?
    # would only make sense if posts are edited without being bumped to top
    # don't know if that happens
  end
end
