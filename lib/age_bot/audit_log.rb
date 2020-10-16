require 'discordrb'
module AgeBot
  module Bot
    class AuditLog

      # Initialize and load last log entries for servers we can grab them from
      # 
      def self.init
        
      end

      # @param [Discordrb::Server] server server instance
      # @param [Discordrb::AuditLogs::Entry]
      def self.add_latest(server, entry)
        # save latest to memory
      end

      def self.save_latest(server, entry)
        # save latest to disk based on server id
      end

      def self.grab

        loop do
          AgeBot::Bot.bot.servers.each_value do |server|

            server.audit_logs(before: before_id).entries
          end
        end
        # TODO: save the last shutdown so we can grab audit logs between that time
        # TODO: add class instance variables for each servers latest
      end

      def self.new_grab
        @last_logs = YAML.load_file
        loop do
          logs      = []
          before_id = Discordrb::IDObject.synthesize(Time.now)

          # Paginate logs until our response contains an entry at or before
          # our latest log.
          loop do
            new_logs = AgeBot::Bot.bot.server(626522675224772658).audit_logs(before: before_id).entries
            # Stop if we're at the beginning
            break if new_logs.empty?

            logs += new_logs
            # Stop if we've hit our latest log
            break if new_logs.any? { |log| log.id <= @last_log }

            # Set the earliest id in the iteration to keep going
            before_id = new_logs.sort_by(&:id).first.id
          end

          # Remove logs that have been processed.
          logs.reject! { |log| log.id <= @last_log }

          puts "#{logs.count} new entries"

          # Set our most recent event`
          @last_log = logs.sort_by(&:id).last.id if logs.any?
          sleep 5
        end
      end

      def self.orig_grab
        @last_log = 0
        loop do
          logs      = []
          before_id = Discordrb::IDObject.synthesize(Time.now)

          # Paginate logs until our response contains an entry at or before
          # our latest log.
          loop do
            new_logs = AgeBot::Bot.bot.server(626522675224772658).audit_logs(before: before_id).entries
            # Stop if we're at the beginning
            break if new_logs.empty?

            logs += new_logs
            # Stop if we've hit our latest log
            break if new_logs.any? { |log| log.id <= @last_log }

            # Set the earliest id in the iteration to keep going
            before_id = new_logs.sort_by(&:id).first.id
          end

          # Remove logs that have been processed.
          logs.reject! { |log| log.id <= @last_log }

          puts "#{logs.count} new entries"

          # Set our most recent event`
          @last_log = logs.sort_by(&:id).last.id if logs.any?
          sleep 5
        end
      end
    end
  end
end