ENV['SINATRA_ENV'] = 'test'
ENV['RACK_ENV']    = ENV['SINATRA_ENV']

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'rack/test'
require 'tiny_gate'
require 'tiny_gate/test_helper'

TinyGate::TestHelper.init!

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.include Rack::Test::Methods

  config.order = 'default'

  config.around(:example, integration: true) do |example|
    begin
      TinyGate::TestHelper.start_server
      example.run
    ensure
      TinyGate::TestHelper.stop_server
    end
  end
end
