require 'json'

module TinyGate
  module Types
    class SwitchOrgResponse

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
      attr_reader :body
    end
  end
end
