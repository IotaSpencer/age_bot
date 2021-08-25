module AgeBot
  module Helpers
    class Discord
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

      # grab member from tag
      # @param [Discordrb::Server] server the discord server/guild
      # @param [String] tag the discord NAME#0000
      def self.member_from_tag(server, tag)
        username = parse_tag(tag)
        AgeBot::Bot.bot.request_chunks(server)
        user = AgeBot::Bot.bot.find_user(username.fetch(:user), username.fetch(:discrim))
        srv  = nil
        if server.is_a?(Discordrb::Server)
          srv = server
        elsif server.is_a?(String)
          srv = AgeBot::Bot.bot.server(server)
        elsif server.is_a?(Integer)
          srv = AgeBot::Bot.bot.server(server.to_s)
        end
        Logger.debug "'server' was a '#{srv.class}'"
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

      # @param [Discordrb::Event] event a discord event to grab information from
      def self.get_members(event)
        server  = event.server
        members = server.members
        members.each do |member|

        end
      end

      # @param [Discordrb::Server] server A discord server instance
      def self.get_server_data(server)
        member_count = server.member_count
        sowner       = server.owner
        sowner_name  = sowner.display_name
        sowner_id    = sowner.id
        name         = server.name
        server_id    = server.id

      end

      # @param [Hash{String => Discordrb::Server}] servers the list of servers the bot is in
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
            embed.add_field(name: "In ServerDB?:", value: AgeBot::Configs::ServerDB.db.servers.to_h.has_key?(server_id.to_s) ? 'yes' : 'no')
          end
        end
        embeds
      end
    end
  end
end