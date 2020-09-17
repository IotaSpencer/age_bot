# frozen_string_literal: true
require 'age_bot/helpers'
require 'age_bot/exceptions'

module AgeBot
  module Bot
    module DiscordCommands
      class Admin
        HELPERS = AgeBot::Bot::Helpers
        extend Discordrb::Commands::CommandContainer
        command(:getmembers) do |event|
          admin = event.user
          raise NotConfirmableError.new(event) unless HELPERS.can_confirm?(admin)
        end
      end
    end
  end
end
