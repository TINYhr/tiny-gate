$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'tiny_gate'

RSpec.configure do |config|
  config.around(:example, integration: true) do |example|
    TinyGate::TestHelper.start_server
    sleep(1)
    example.run
    TinyGate::TestHelper.stop_server
  end
end
