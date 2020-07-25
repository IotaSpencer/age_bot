# frozen_string_literal: true

module AgeBot
  module Bot
    module DiscordEvents
      module RoleAudit
        extend Discordrb::EventContainer
        member_join do |event|
          server_id = event.server.id.to_s
          event.bot.request_chunks(server_id)
        end
      end
    end
  end
end
