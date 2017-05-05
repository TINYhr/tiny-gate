require 'json'
require_relative 'user'

module TinyGate
  module Types
    class SwitchOrgResponse
      attr_reader :body

      def initialize(response)
        @response = response
        @body = JSON.parse(response.body)
      end

      def success?
        response.status == 200
      end

      def new_token_url
        @body['url']
      end

      private

      attr_reader :response
    end
  end
end
