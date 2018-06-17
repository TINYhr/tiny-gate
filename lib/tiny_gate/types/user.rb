require 'dry-struct'
require_relative '../types'
require_relative 'active_permission'

module TinyGate
  module Types
    class User < Dry::Struct
      transform_keys(&:to_sym)

      attribute :id, Types::Integer
      attribute :email, Types::String
      attribute :first_name, Types::String
      attribute :last_name, Types::String
      attribute :created_at, Types::DateTime.meta(omittable: true)
      attribute :avatar_url, Types::String.meta(omittable: true)
      attribute :token, Types::String
      attribute :admin_id, Types::Integer.meta(omittable: true)
      attribute :current_permission, Types::ActivePermission.meta(omittable: true)
      attribute :active_permissions, Types::Strict::Array.of(Types::ActivePermission)

      def data
        {
          user_id: id,
          token: token
        }
      end
    end
  end
end
