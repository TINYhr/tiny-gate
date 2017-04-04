require 'dry-struct'
require_relative '../types'

module TinyGate
  module Types
    class ActivePermission < Dry::Struct
      constructor_type :symbolized

      attribute :id, Types::Int
      attribute :app_id, Types::Int
      attribute :user_id, Types::Int
      attribute :organization_id, Types::Int
      attribute :organization_name, Types::Int
      attribute :role_id, Types::Int
      attribute :role_name, Types::Int
    end
  end
end
