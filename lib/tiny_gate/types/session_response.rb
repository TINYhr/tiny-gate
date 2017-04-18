require 'json'
require_relative 'user'

module TinyGate
  module Types
    class SessionResponse
      attr_reader :body

      def initialize(response)
        @response = response
        @body = JSON.parse(response.body)
      end

      def success?
        response.status == 200
      end

      def global_user
        Types::User[body]
      end

      private

      attr_reader :response
    end
  end
end
