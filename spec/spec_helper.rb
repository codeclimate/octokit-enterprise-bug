require "webmock/rspec"

Dir["spec/support/**/*.rb"].each { |f| load f }

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

WebMock.disable_net_connect!
