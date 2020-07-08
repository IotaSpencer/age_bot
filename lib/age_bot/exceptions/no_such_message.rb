module AgeBot
  module Execeptions
    class NoSuchMessageError < StandardError
      def initialize(event, id, msg = nil)
        msg  = msg || "Message #{event.user} is not owner"
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
