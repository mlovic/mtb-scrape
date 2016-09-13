require_relative 'helpers'

require 'vcr'
require 'webmock'
require 'active_record'
require 'database_cleaner'
require 'factory_girl'

ActiveRecord::Base.logger = Logger.new('db/test_debug.log')
configuration = YAML::load(IO.read('db/database.yml'))
ActiveRecord::Base.establish_connection(configuration['test'])

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  #config.allow_http_connections_when_no_cassette = true
  #config.preserve_exact_body_bytes do |http_msg|
  #config.before_record do |i|
    #i.response.body.force_encoding('UTF-7')
  #end
end

RSpec.configure do |config|

  config.include Helpers
  config.include FactoryGirl::Syntax::Methods

  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true

  config.before(:each) do
    DatabaseCleaner.clean_with(:truncation) if self.class.metadata[:loads_DB]
  end

  config.example_status_persistence_file_path = "tmp/spec/examples.txt"
  end

  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = 'doc'
  end
end
