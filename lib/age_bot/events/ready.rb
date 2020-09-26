# frozen_string_literal: true
require 'age_bot/scheduler'
module AgeBot
  module Bot
    module DiscordEvents
      module Ready
        extend Discordrb::EventContainer
        ready do |event|
          event.bot.watching = "#{event.bot.servers.length - 1} servers for underage people."
        end
        #ready do |event|
        #  bot   = event.bot
        #   alogs = AgeBot::Bot::Schedules.add('alogs')
        #   alogs.every '1h' do
        #     AgeBot::Bot::AuditLog.grab
        #   end
        #end
      end
    end
  end
end
