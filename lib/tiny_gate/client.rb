require 'dry-configurable'
require 'http'
require_relative 'types/session_response'

module TinyGate
  class Client
    extend Dry::Configurable

    setting :root_url, ENV['AUTHENTICATION_ROOT_URL']
    setting :app_id, ENV['APP_ID']

    def initialize(root_url = self.class.config.root_url, app_id = self.class.config.app_id)
      @root_url = root_url
      @app_id = app_id
    end

    def login_url
      "#{root_url}/auth/sessions/new?app_id=#{app_id}"
    end

    def logout_url
      "#{root_url}/signout"
    end

    def validate(payload)
      response = HTTP.post(validate_url, json: payload)
      Types::SessionResponse.new(response)
    end

    def signed_in?(token, user_id)
      response = HTTP.post(validate_signed_in_url, json: {user_id: user_id, token: token})
      response.status == 200
    end

    def fetch_user(token, user_id)
      response = HTTP.post(me_url, json: {user_id: user_id, token: token})
      Types::SessionResponse.new(response)
    end

    private

    attr_reader :root_url, :app_id


    def validate_url
      "#{auth_base_url}/validate"
    end

    def validate_signed_in_url
      "#{auth_base_url}/signed_in"
    end

    def me_url
      "#{auth_base_url}/me"
    end

    def auth_base_url
      "#{root_url}/auth/sessions"
    end
  end
end
