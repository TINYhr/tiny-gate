require 'sinatra'
require 'json'
require_relative 'user_client'
require_relative 'user_repository'
require_relative '../client'

TinyGate::Client.configure do |config|
  config.root_url = TinyGate::TestHelper::UserClient::ROOT_URL
end

module TinyGate
  module TestHelper
    class DummyServer < Sinatra::Application
      RESULT_URL = "http://app.lvh.me:31337/session/callback?validation_ticket=%{user_token}"

      post '/signout' do
      end

      get '/auth/sessions/new' do
        haml <<-HAML

%form{action: "/auth/sessions", method: "post"}\n
  %input.form-control{name: "session[email]"}\n
  %input.form-control{name: "session[password]"}\n
  %button.btn-success{type: "submit"} Sign In

        HAML
      end

      post '/auth/sessions' do
        user = UserRepository.find_by_email(params[:session][:email])
        if user && user.password == params[:session][:password]
          redirect to(RESULT_URL % {user_token: user.token})
        else
          "There is no user with email #{params[:session][:email]} and password: #{params[:session][:password]}"
        end
      end

      post '/auth/sessions/validate' do
        data = request.env['rack.input'].read
        json_params = JSON.parse(data)
        user = UserRepository.find_by_token(json_params['ticket'])

        if user
          user.data.to_json
        else
          status 401
          body '{"errors": "Invalid Token"}'
        end
      end

      post '/auth/sessions/signed_in' do
        data = request.env['rack.input'].read
        json_params = JSON.parse(data)
        user = UserRepository.find_by_id(json_params['user_id'])

        if user && user.token == json_params['token']
          status 200
        else
          status 401
          body 'Invalid token'
        end
      end

      post '/auth/sessions/me' do
        data = request.env['rack.input'].read
        json_params = JSON.parse(data)
        user = UserRepository.find_by_id(json_params['user_id'])

        if user && user.token == json_params['token']
          user.data.to_json
        else
          status 401
          body '{"errors": "Invalid Token"}'
        end
      end

      post '/auth/sessions/switch_org' do
        data = request.env['rack.input'].read
        json_params = JSON.parse(data)
        user_id = json_params['user_id']
        organization_id = json_params['organization_id']
        user = UserRepository.find_by_id(user_id)

        if user
          url = RESULT_URL % {user_token: user.token}
          body ({"url" => url}.to_json)
        else
          status 403
          body '{"url": ""}'
        end
      end

      post '/add_user' do
        user = UserRepository.add_user(
          id: params[:id],
          email: params[:email],
          password: params[:password]
        )
        user.data.to_json
      end

      post '/add_permission' do
        user = UserRepository.find_by_id(params[:user_id])
        user.add_permission(
          params[:permission_id],
          params[:role_id],
          params[:organization_id]
        )
      end

      post '/reset' do
        UserRepository.reset
      end
    end
  end
end
