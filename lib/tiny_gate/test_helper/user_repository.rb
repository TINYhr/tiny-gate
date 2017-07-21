require_relative 'user'

module TinyGate
  module TestHelper
    class UserRepository
      @@users = Set.new

      class << self
        def add_user(id:, email:, password:, first_name: 'First', last_name: 'Last')
          User.new(id, email, password, first_name, last_name).tap do |user|
            @@users << user
          end
        end

        def find_by_email(email)
          @@users.find { |user| user.email == email }
        end

        def find_by_id(id)
          @@users.find { |user| user.id.to_s == id.to_s }
        end

        def find_by_token(token)
          @@users.find { |user| user.token == token }
        end

        def reset
          @@users = Set.new
        end

        def users
          @@users
        end
      end
    end
  end
end
