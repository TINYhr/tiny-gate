module TinyGate
  module TestHelper
    class ApplicationController < Sinatra::Base

      configure do
        set :environment,   ENV['SINATRA_ENV'] || ENV['RACK_ENV']
        set :root,          __dir__
        set :views,         File.join(__dir__, 'views')
      end

      after do
        if Sinatra::Base.development?
          puts
          puts "==> params: #{params.inspect}"
          puts
        end
      end

      get '/' do
        erb :'/welcome.html'
      end

    end
  end
end
