# frozen_string_literal: true

require 'age_bot/helpers/server_helpers'
module AgeBot
  module Bot
    class Helpers
      include ServerHelpers
      # @param [Discordrb::Member] member a 'member' on a server
      def self.can_confirm?(member)
        results = []
        AgeBot::Configs::ServerDB.db.servers[member.server.id.to_s].can_confirm.each do |hsh|
          results << member.role?(hsh['id']) if member.server.role(hsh['id'])
        end
        results.any?
      end

      # grab username from tag simply
      # @param [String] tag

      def self.parse_tag(tag)
        user, discrim = *tag.split('#')
        {user: user, discrim: discrim}
      end

      # @param [Discordrb::Server,String,Integer] server the discord server/guild
      # @param [String] tag the discord NAME#0000
      def self.member_from_tag(server, tag)
        username = parse_tag(tag)
        AgeBot::Bot.bot.request_chunks(server)
        user = AgeBot::Bot.bot.find_user(username.fetch(:user), username.fetch(:discrim))
        srv = nil
        if server.is_a?(Discordrb::Server)
          srv = server
        elsif server.is_a?(String)
          srv = AgeBot::Bot.bot.server(server)
        elsif server.is_a?(Integer)
          srv = AgeBot::Bot.bot.server(server.to_s)
        end
        Logger.debug "'server' was a '#{server.class}'"
        nil if srv.nil?
        srv.member(AgeBot::Bot.bot.find_user(username[:user], username[:discrim]).id.to_s, true)
      end

      def self.parse_mention(mention, server = nil, event: nil)
        # Mention format: <@id>
        if /<@!?(?<id>\d+)>/ =~ mention # NickName Mention
          event.bot.user(id)
        elsif /<@&(?<id>\d+)>/ =~ mention # Role Mention
          return server.role(id) if server

          @servers.each_value do |element|
            role = element.role(id)
            return role unless role.nil?
          end
          # Return nil if no role is found
          nil
        elsif /<\#(?<id>\d+)>/ =~ mention # Channel Mention
          event.bot.channel(id.to_s)

        elsif /<(?<animated>a)?:(?<name>\w+):(?<id>\d+)>/ =~ mention # Emoji Mention
          emoji(id) || Emoji.new({'animated' => !animated.nil?, 'name' => name, 'id' => id}, self, nil)
        end
      end
    end
  end
end
