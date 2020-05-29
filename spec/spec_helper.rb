# require 'ruby-debug'

root_dir = File.join(File.dirname(__FILE__), '..')
Dir.glob("#{root_dir}/lib/**/*.rb").sort.each { |file| require file }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = 'spec/failures.txt'
end

DSpace.load
DSpace.login('admin@localhost')
