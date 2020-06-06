if ENV['COVERAGE']
  require 'simplecov'

  SimpleCov.start 'rails' do
    add_filter %r{^/test/}
  end
end

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...
end
