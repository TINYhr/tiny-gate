module TinyGate
  module TestHelper
    class User
      attr_reader :id, :email, :password, :token

      def initialize(id, email, password)
        @id          = id
        @email       = email
        @password    = password
        @token       = SecureRandom.hex
        @permissions = Set.new
      end

      def add_permission(permission_id, role_id, role_name, organization_id)
        @permissions << OpenStruct.new(
          id:              permission_id,
          role_id:         role_id,
          role_name:       role_name,
          organization_id: organization_id
        )
      end

      def data
        {
          id:                 id,
          email:              email,
          token:              token,
          first_name:         'First',
          last_name:          'Last',
          active_permissions: active_permissions
        }.tap { |h| puts "==> data: #{h.inspect}" if Sinatra::Base.development? }
      end

      private

      def active_permissions
        @permissions.map do |permission|
          {
            id:                permission.id,
            app_id:            nil,
            user_id:           id,
            role_id:           permission.role_id,
            role_name:         permission.role_name,
            organization_id:   permission.organization_id,
            organization_name: nil
          }
        end
      end
    end
  end
end
