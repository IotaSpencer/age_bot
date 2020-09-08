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

      def self.parse_mention(mention, server = nil, event: nil)
        # Mention format: <@id>
        if /<@!?(?<id>\d+)>/ =~ mention # NickName Mention
          event.bot.user(id)
        elsif /<@&(?<id>\d+)>/ =~ mention # Role Mention
          return server.role(id) if server
          @servers.values.each do |element|
            role = element.role(id)
            return role unless role.nil?
          end
          # Return nil if no role is found
          nil
        elsif /<\#(?<id>\d+)>/ =~ mention # Channel Mention
          return event.bot.channel(id.to_s)

        elsif /<(?<animated>a)?:(?<name>\w+):(?<id>\d+)>/ =~ mention # Emoji Mention
          emoji(id) || Emoji.new({'animated' => !animated.nil?, 'name' => name, 'id' => id}, self, nil)
        end
      end
    end
  end
end
