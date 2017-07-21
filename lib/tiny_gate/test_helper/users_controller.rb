require_relative 'user_repository'

module TinyGate
  module TestHelper
    class UsersController < ApplicationController

      post '/add_user' do
        user = UserRepository.add_user(
          id:         params[:id],
          email:      params[:email],
          password:   params[:password],
          first_name: params[:first_name],
          last_name:  params[:last_name]
        )
        user.data.to_json
      end

      post '/add_permission' do
        user = UserRepository.find_by_id(params[:user_id])
        user.add_permission(
          params[:permission_id],
          params[:role_id],
          params[:role_name],
          params[:organization_id],
          params[:organization_name],
          params[:app_id]
        )
        status 200
      end

      post '/reset' do
        UserRepository.reset
        status 200
      end

    end
  end
end
