# frozen_string_literal: true

module AgeBot
  module Bot
    module DiscordEvents
      module Ready
        extend Discordrb::EventContainer
        ready do |event|
          event.bot.watching = "#{event.bot.servers.length - 1} servers for underage people."
        end
      end
    end
  end
end
