# frozen_string_literal: true

module AgeBot
  module Execeptions
    class NoSuchMessageError < StandardError
      def initialize(event, id, msg = nil)
        msg ||= "Message '#{id}' does not exist"
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
