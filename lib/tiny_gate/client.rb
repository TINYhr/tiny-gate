require 'dry-configurable'
require 'http'
require_relative 'types/session_response'
require_relative 'types/switch_org_response'

module TinyGate
  class Client
    extend Dry::Configurable

    setting :root_url, ENV['AUTHENTICATION_ROOT_URL']
    setting :app_id, ENV['APP_ID']
    setting :callback_token, ENV['AUTHENTICATED_CALLBACK_TOKEN']

    def initialize(root_url = self.class.config.root_url, app_id = self.class.config.app_id, callback_token = self.class.config.callback_token)
      @root_url = root_url
      @app_id = app_id
      @callback_token = callback_token
    end

    def login_url
      "#{root_url}/auth/sessions/new?app_id=#{app_id}#{callback_token_params}"
    end

    def logout_url
      "#{root_url}/signout"
    end

    def validate(payload)
      response = HTTP.post(validate_url, json: payload.merge(app_id: app_id))
      Types::SessionResponse.new(response)
    end

    def signed_in?(token, user_id)
      response = HTTP.post(validate_signed_in_url, json: {user_id: user_id, token: token, app_id: app_id})
      response.status == 200
    end

    def fetch_user(token, user_id)
      response = HTTP.post(me_url, json: {user_id: user_id, token: token, app_id: app_id})
      Types::SessionResponse.new(response)
    end

    def switch_org(token, organization_id, user_id)
      response = HTTP.post(switch_org_url, json: {token: token, organization_id: organization_id, user_id: user_id, app_id: app_id})
      Types::SwitchOrgResponse.new(response).new_token_url
    end

    private

    attr_reader :root_url, :app_id, :callback_token

    def callback_token_params
      if callback_token
        "&callback_token=#{callback_token}"
      end
    end

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

    def switch_org_url
      "#{root_url}/auth/sessions/switch_org"
    end
  end
end
