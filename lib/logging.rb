require 'logger'

# code copied from http://stackoverflow.com/a/6768164/4088940
module Logging

  def logger
    Logging.logger
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end
end
