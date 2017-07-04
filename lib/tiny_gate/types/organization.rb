require 'dry-struct'
require_relative '../types'

module TinyGate
  module Types
    class Organization < Dry::Struct
      constructor_type :symbolized

      attribute :id, Types::Int
      attribute :name, Types::String
    end
  end
end
