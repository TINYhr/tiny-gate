module TinyGate
  module TestHelper
    DummyServer = Rack::Builder.new do
      use SessionsController
      use UsersController
      run ApplicationController
    end
  end
end
