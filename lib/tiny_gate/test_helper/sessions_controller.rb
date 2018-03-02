require_relative 'user_repository'

module TinyGate
  module TestHelper
    class SessionsController < ApplicationController
      RESULT_URL = 'http://app.lvh.me:31337/session/callback?validation_ticket=%{user_token}'

      get '/auth/sessions/new' do
        erb :'/sessions/new.html'
      end

      post '/auth/sessions' do
        user = UserRepository.find_by_email(params[:session][:email])
        if user && user.password == params[:session][:password]
          redirect to(format(RESULT_URL, user_token: user.token))
        else
          "There is no user with email #{params[:session][:email]} and password: #{params[:session][:password]}"
        end
      end

      post '/auth/sessions/validate' do
        content_type :json

        data = request.env['rack.input'].read
        json_params = JSON.parse(data)
        user = UserRepository.find_by_token(json_params['ticket'])

        if user
          user.data.to_json
        else
          status 401
          { errors: 'Invalid Token' }.to_json
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
          body 'Invalid Token'
        end
      end

      post '/auth/sessions/me' do
        content_type :json

        data = request.env['rack.input'].read
        json_params = JSON.parse(data)
        user = UserRepository.find_by_id(json_params['user_id'])

        if user && user.token == json_params['token']
          user.sign_in
          user.data.to_json
        else
          status 401
          { errors: 'Invalid Token' }.to_json
        end
      end

      post '/auth/sessions/switch_org' do
        content_type :json

        data = request.env['rack.input'].read
        json_params = JSON.parse(data)
        user_id = json_params['user_id']
        organization_id = json_params['organization_id']
        user = UserRepository.find_by_id(user_id)

        if user
          user.sign_in(organization_id)
          url = format(RESULT_URL, user_token: user.token)
        else
          url = ''
          status 403
        end
        { url: url }.to_json
      end

      post '/signout' do
      end
    end
  end
end
