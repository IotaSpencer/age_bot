# frozen_string_literal: true

module AgeBot
  module Bot
    class Helpers
      # @param [Discordrb::Member] member a 'member' on a server
      def self.can_confirm?(member)
        results = []
        AgeBot::Configs::ServerDB.db.servers[member.server.id.to_s].can_confirm.each do |hsh|
          results << member.role?(hsh['id']) if member.server.role(hsh['id'])
        end
        results.any?
      end

      # @param [Discordrb::Server,String,Integer]
      # @param [String] tag the discord NAME#0000
      def self.member_from_tag(server, tag)
        user_name, user_discrim = *tag.split('#')
        AgeBot::Bot.bot.request_chunks(server)
        user                    = AgeBot::Bot.bot.find_user(user_name, user_discrim)
        case
        when server.is_a?(Discordrb::Server)
          srv = server
        when server.is_a?(String)
          srv = AgeBot::Bot.bot.server(server)
        when server.is_a?(Integer)
          srv = AgeBot::Bot.bot.server(server.to_s)
        end
        nil if srv.nil?
        srv.member(AgeBot::Bot.bot.find_user(user_name, user_discrim).id.to_s)
      end
    end
  end
end
