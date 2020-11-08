# frozen_string_literal: true

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration

ENV["ENV"] = "test"

require_relative "../system/lib"

require "rom-factory"
require "database_cleaner/sequel"

Factory = ROM::Factory.configure do |config|
  config.rom = Lib[:rom]
end

Pathname.glob("#{__dir__}/factories/**/*.rb").each(&method(:require))

DatabaseCleaner[:sequel].strategy = :transaction

RSpec.configure do |config|
  config.before(:each) { DatabaseCleaner[:sequel].start }
  config.after(:each) { DatabaseCleaner[:sequel].clean }

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
