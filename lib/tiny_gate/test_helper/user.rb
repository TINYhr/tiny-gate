module TinyGate
  module TestHelper
    class User
      attr_reader :id, :email, :password, :first_name, :last_name, :token
      attr_accessor :current_organization_id

      def initialize(id, email, password, first_name = 'First', last_name = 'Last')
        @id          = id
        @email       = email
        @password    = password
        @first_name  = first_name
        @last_name   = last_name
        @token       = SecureRandom.hex
        @permissions = Set.new
      end

      def sign_in(organization_id = nil)
        self.current_organization_id = organization_id || @permissions.first.organization_id
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
          current_permission: current_permission,
          active_permissions: active_permissions
        }
      end

      private

      def current_permission
        permission = find_current_permission
        permission && to_hash(permission)
      end

      def find_current_permission
        current_organization_id && @permissions.detect { |p| p.organization_id == current_organization_id }
      end

      def active_permissions
        @permissions.map { |permission| to_hash(permission) }
      end

      def to_hash(permission)
        {
          id:                permission.id,
          role_id:           permission.role_id,
          role_name:         permission.role_name,
          organization_id:   permission.organization_id,
          organization_name: permission.organization_name,
          app_id:            permission.app_id,
          user_id:           id
        }
      end
    end
  end
end
