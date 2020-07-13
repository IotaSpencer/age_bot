module AgeBot
  module Execeptions
    class NotConfirmableError < StandardError
      def initialize(event, msg = nil)
        msg  = msg || "#{event.user} cannot confirm users. (Does not have any roles listed as confirmable)"
        rply = event.respond(msg)
        Timeout.timeout(2.5) do
          event.delete
          rply.delete
        end
        super(msg)
      end
    end
  end
end
