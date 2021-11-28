require 'age_bot/logger'
module AgeBot
  module Helpers
    class Discord
      # @param [Discordrb::Member] member a 'member' on a server
      # @return [Array<Discordrb::Member>]
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
        { user: user, discrim: discrim }
      end

      # grab member from tag
      # @param [Discordrb::Server] server the discord server/guild
      # @param [tag] tag User Object
      def self.member_from_tag(server, user)
        AgeBot::Bot.bot.request_chunks(server)
        username = self.parse_tag(user)
        srv = nil
        if server.is_a?(Discordrb::Server)
          srv = server
        elsif server.is_a?(String)
          srv = AgeBot::Bot.bot.server(server)
        elsif server.is_a?(Integer)
          srv = AgeBot::Bot.bot.server(server.to_s)
        else
          Logger.debug "'server' was neither String, Integer, or Discordrb::Server"
        end
        Logger.debug "'server' was a '#{srv.class}'"
        nil if srv.nil?
        srv.member(AgeBot::Bot.bot.find_user(username[:user], username[:discrim]).id.to_s, true)
      end

      # @param [Discordrb::Server] server a discord server to grab information from
      def self.get_members(server)
        server = event.server
        members = server.members
        members.each do |member|

        end
      end

      # @param [Discordrb::Events::ServerMemberAddEvent,Discordrb::Events::PrivateMessageEvent] event the event object
      # @param [Integer,Discordrb::Server] server Discord Server/Guild Object/ID
      # @return [Discordrb::Member] if server is not nil
      # @return [Discordrb::User] if server is nil
      def self.cache_member_from_event(event, server: nil)
        member = nil
        user = event.user
        user_id = user.id
        user_name = user.username
        user_a_id = user.avatar_id
        user_discrim = user.discrim
        cached_user = event.bot.ensure_user({
                                              'id' => user_id,
                                              'username' => user_name,
                                              'avatar_id' => user_a_id,
                                              'discriminator' => user_discrim
                                            })
        Logger.debug("Cached a user")
        Logger.debug("#{cached_user.inspect}")
        if server
          if server.is_a?(Integer)
            member = event.bot.server(server).member(user_id, true)
          elsif server.is_a?(Discordrb::Server)
            member = server.member(user_id, true)
          end

        end
        if member
          member
        else
          cached_user
        end
      end

      # @param [Discordrb::Server] server A discord server instance
      # @return [NilClass]
      def self.get_server_data(server)
        member_count = server.member_count
        sowner = server.owner
        sowner_name = sowner.display_name
        sowner_id = sowner.id
        name = server.name
        server_id = server.id

      end

      # @param [Hash{Symbols => Discordrb::Server}] servers the list of servers the bot is in
      def self.make_server_embeds(servers)
        embeds = []
        servers.each do |server_id, server_data|
          embeds << Discordrb::Webhooks::Builder.new.add_embed do |embed|
            embed.title = server_id
            embed.add_field(name: "Server Name:", value: server_data.name, inline: true)
            embed.add_field(name: "Member Count:", value: server_data.member_count.to_s, inline: true)
            embed.add_field(name: "Server Owner NickName:", value: server_data.owner.on(server_id).display_name, inline: true)
            embed.add_field(name: "Server Owner Distinct:", value: server_data.owner.distinct, inline: true)
            embed.add_field(name: "Server Owner ID:", value: server_data.owner.id, inline: true)
            embed.add_field(name: "Large?:", value: server_data.large? ? 'yes' : 'no', inline: true)
            embed.add_field(name: "In ServerDB?:", value: AgeBot::Configs::ServerDB.db.servers.to_h.has_key?(server_id.to_s.to_sym) ? 'yes' : 'no')
          end
        end
        embeds
      end
    end
  end
end