require 'age_bot/exceptions/not_owner_error'
require 'age_bot/helpers'
module AgeBot
  module Bot
    module DiscordCommands
      # Confirm the age using a command
      module ConfirmAge
        HELPERS = AgeBot::Bot::Helpers
        extend Discordrb::Commands::CommandContainer
        command(:confirm, help_available: false, min_args: 2) do |event, *args|
          admin        = event.user.id
          user         = args[0]
          user_name    = user.split('#')[0]
          user_discrim = user.split('#')[1]
          user_id      = event.bot.find_user(user_name, user_discrim).id
          member       = event.server.member(user_id)
          if HELPERS.can_confirm?(member)
            message_id = args[1]
            puts AgeBot::Bot.bot.find_user(user_name, user_discrim)
            event.channel.delete_message(message_id)
          end
          command(:reject, help_available: false, min_args: 1) do |event, message_id|
            user = event.author
            if HELPERS.can_confirm? user
              channel = event.channel
              begin
                channel.delete_message(message_id)
              rescue Discordrb::Errors::UnknownMessage
              end
            end
          end
        end
      end
    end
