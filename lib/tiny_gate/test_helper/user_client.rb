require 'http'

module TinyGate
  module TestHelper
    class UserClient
      ROOT_URL = 'http://localhost:31338'

      def initialize(url = ROOT_URL)
        @url = url
      end

      def add_user(payload)
        response = HTTP.post(add_user_url, form: payload)
        response.body
      end

      def add_permission(payload)
        HTTP.post(add_permission_url, form: payload)
      end

      def reset
        HTTP.post("#{@url}/reset")
      end

      private

      def add_user_url
        "#{@url}/add_user"
      end

      def add_permission_url
        "#{@url}/add_permission"
      end
    end
  end
end
