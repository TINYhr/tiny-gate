require 'dry-struct'
require_relative '../types'

module TinyGate
  module Types
    class ActivePermission < Dry::Struct
      transform_keys(&:to_sym)

      attribute :id, Types::Integer
      attribute :app_id, Types::Integer
      attribute :user_id, Types::Integer
      attribute :organization_id, Types::Integer
      attribute :organization_name, Types::String
      attribute :role_id, Types::Integer
      attribute :role_name, Types::String
    end
  end
end
