module TinyGate
  module Strategies
    class TicketStrategy < Warden::Strategies::Base
      def valid?
        !!params['validation_ticket']
      end

      def authenticate!
        validator = Talent::Sessions::TicketValidator.new
        result = validator.validate(params['validation_ticket'])

        if result.success?
          session = result.session
          success!(session)
        else
          throw(:warden)
        end
      end
    end
  end
end

Warden::Strategies.add(:ticket, TinyGate::Strategies::TicketStrategy)
