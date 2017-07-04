require 'dry-struct'
require_relative '../types'
require_relative 'active_permission'
require_relative 'organization'

module TinyGate
  module Types
    class User < Dry::Struct
      constructor_type :symbolized

      attribute :id, Types::Int
      attribute :email, Types::String
      attribute :first_name, Types::String
      attribute :last_name, Types::String
      attribute :avatar_url, Types::String
      attribute :token, Types::String
      attribute :admin_id, Types::Int
      attribute :current_permission, Types::ActivePermission
      attribute :active_permissions, Types::Strict::Array.member(Types::ActivePermission)
      attribute :accessible_organizations, Types::Strict::Array.member(Types::Organization)

      def data
        {
          user_id: id,
          token: token
        }
      end
    end
  end
end
