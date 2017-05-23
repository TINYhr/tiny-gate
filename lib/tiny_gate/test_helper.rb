require 'daemons'
require 'rack/handler/webrick'
require_relative 'test_helper/dummy_server'

module TinyGate
  module TestHelper
    def self.start_server
      Daemons.call(multiple: true, shush: true) do
        Rack::Handler::WEBrick.run(
          TinyGate::TestHelper::DummyServer,
          Host: 'localhost',
          Port: 31338
        )
      end
    end

    def self.stop_server
      Daemons.group.stop_all(true)
    end
  end
end
