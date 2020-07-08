module AgeBot
  module Execeptions
    class NotOwnerError < StandardError
      def initialize(event, msg = nil)
        msg = msg || "User #{event.user} is not owner"
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
