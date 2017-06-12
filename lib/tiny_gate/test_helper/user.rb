require 'securerandom'
require 'ostruct'

module TinyGate
  module TestHelper
    class User
      attr_reader :id, :email, :password, :token

      def initialize(id, email, password)
        @id = id
        @email = email
        @password = password
        @token = SecureRandom.hex
        @permissions = Set.new
      end

      def add_permission(permission_id, role_id, organization_id)
        @permissions << OpenStruct.new(
          id: permission_id,
          role_id: role_id,
          organization_id: organization_id
        )
      end

      def data
        {
          id: id,
          email: email,
          token: token,
          first_name: 'First',
          last_name: 'Last',
          active_permissions: active_permissions,
          admin_id: ''
        }
      end

      private

      def active_permissions
        @permissions.map do |permission|
          {
            id: permission.id,
            app_id: nil,
            user_id: id,
            role_id: permission.role_id,
            role_name: nil,
            organization_id: permission.organization_id,
            organization_name: nil
          }
        end
      end
    end
  end
end
