module AgeBot
  module Helpers
    class AuditLog
      def self.check_for_lastlogs_file

      end

      # @param [Discordrb::Server] server
      def self.check_for_lastlogs_server(server) end

      # @param [Discordrb::Server] server server instance
      def self.check_sperms_for_audit(server)
        server.bot.permission?(:view_audit_log)

      end
    end
  end
end