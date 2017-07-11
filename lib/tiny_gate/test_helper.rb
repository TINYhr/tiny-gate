require 'ostruct'
require 'securerandom'
require 'daemons'
require 'rack/handler/webrick'
require 'sinatra'
require 'tiny_gate/types'

require_relative 'test_helper/user'
require_relative 'test_helper/user_repository'
require_relative 'test_helper/user_client'
require_relative 'test_helper/application_controller'
require_relative 'test_helper/sessions_controller'
require_relative 'test_helper/users_controller'
require_relative 'test_helper/dummy_server'

module TinyGate
  module TestHelper
    def self.init!
      TinyGate::Client.configure do |config|
        config.root_url = TinyGate::TestHelper::UserClient::ROOT_URL
      end
    end

    def self.run_server
      Rack::Handler::WEBrick.run(
        DummyServer,
        Host: 'localhost',
        Port: 31338
      )
    end

    def self.start_server
      Daemons.call(multiple: true, shush: true) do
        run_server
      end
      sleep 1
    end

    def self.stop_server
      return unless Daemons.group

      Daemons.group.applications.each do |application|
        begin
          Process.kill('KILL', application.pid.pid)
          Process.wait(application.pid.pid)
        rescue
        end
      end
    end
  end
end
