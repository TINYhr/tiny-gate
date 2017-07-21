module TinyGate
  module TestHelper
    class User
      attr_reader :id, :email, :password, :first_name, :last_name, :token

      def initialize(id, email, password, first_name = 'First', last_name = 'Last')
        @id          = id
        @email       = email
        @password    = password
        @first_name  = first_name
        @last_name   = last_name
        @token       = SecureRandom.hex
        @permissions = Set.new
      end

      def add_permission(permission_id, role_id, role_name, organization_id, organization_name = nil, app_id = nil)
        @permissions << OpenStruct.new(
          id:                permission_id,
          role_id:           role_id,
          role_name:         role_name,
          organization_id:   organization_id,
          organization_name: organization_name,
          app_id:            app_id
        )
      end

      def data
        {
          id:                 id,
          email:              email,
          token:              token,
          first_name:         first_name,
          last_name:          last_name,
          active_permissions: active_permissions
        }
      end

      private

      def active_permissions
        @permissions.map do |permission|
          {
            id:                permission.id,
            role_id:           permission.role_id,
            role_name:         permission.role_name,
            organization_id:   permission.organization_id,
            organization_name: permission.organization_name,
            app_id:            permission.app_id,
            user_id:           id,
          }
        end
      end
    end
  end
end
