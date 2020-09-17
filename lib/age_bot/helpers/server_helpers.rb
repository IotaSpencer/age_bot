require 'discordrb/webhooks/builder'
module AgeBot
  module Bot
    class Helpers
      module ServerHelpers
        # @param [Discordrb::Event] event a discord event to grab information from
        def self.get_members(event)
          server  = event.server
          members = server.members
          members.each do |member|

          end
        end

        # @param [Discordrb::Server] server A discord server instance
        def get_server_data(server)
          member_count = server.member_count
          sowner       = server.owner
          sowner_name  = sowner.display_name
          sowner_id    = sowner.id
          name         = server.name
          server_id    = server.id

        end

        # @param [Hash{String => Discordrb::Server}] servers the list of servers the bot is in
        def make_server_embeds(servers)
          servers.each do |server_id, server_data|
            embeds << Discordrb::Webhooks::Builder.new.add_embed do |embed|
              embed.title = server_id
              embed.add_field(name: "Server Name:", value: server_data.name)
              embed.add_field(name: "Member Count:", value: server_data.member_count.to_s)
              embed.add_field(name: "Server Owner NickName:", value: server_data.owner.on(server_id).display_name)
              embed.add_field(name: "Server Owner Distinct:", value: server_data.owner.distinct)
              embed.add_field(name: "Server Owner ID:", value: server_data.owner.id)
              embed.add_field(name: "Large?:", value: server_data.large? ? 'yes' : 'no')
              embed.add_field(name: "In ServerDB?:", value: AgeBot::Configs::ServerDB.db.servers.has_key?(server_id) ? 'yes' : 'no')
            end
          end
          embeds
        end
      end
    end
  end
end
