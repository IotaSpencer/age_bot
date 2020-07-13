require 'age_bot/exceptions/not_owner_error'
require 'age_bot/helpers'
module AgeBot
  module Bot
    module DiscordCommands
      # Confirm the age using a command
      module ConfirmAge
        HELPERS = AgeBot::Bot::Helpers
        extend Discordrb::Commands::CommandContainer
        command(:confirm, help_available: false, min_args: 2) do |event, user, message_id|
          admin        = event.server.member(event.user.id)
          user_name    = user.split('#')[0]
          user_discrim = user.split('#')[1]
          user_id      = event.bot.find_user(user_name, user_discrim).id
          member       = event.server.member(user_id)
          if HELPERS.can_confirm?(admin)
            if member.role?(AgeBot::Configs::ServerDB.db.servers[member.server.id.to_s].role)
              event.respond("#{member.distinct} already has the required role '#{event.server.role(AgeBot::Configs::ServerDB.db.servers[event.server.id.to_s].role).name}'")
              return
            else
              member.add_role(AgeBot::Configs::ServerDB.db.servers[member.server.id.to_s].role)
              event.channel.delete_message(message_id)
              event.respond("#{member.distinct} was confirmed to be a(n) #{event.server.role(AgeBot::Configs::ServerDB.db.servers[event.server.id.to_s].role).name}")
            end
          else
            raise AgeBot::Execeptions::NotConfirmableError.new(event)
          end
        end

        command(:reject, help_available: false, min_args: 3) do |event, user, message_id, *reason|
          admin                   = event.server.member(event.author.id)
          user_name, user_discrim = *user.split('#')
          user                    = AgeBot::Bot::Helpers.member_from_tag(event.server, user)
          if HELPERS.can_confirm?(admin)
            channel = event.channel
            begin

              channel.send_message("#{user.distinct} was rejected on grounds of \"#{reason.join(' ')}\"")
              user.pm("Your submission was rejected due to the reason — #{reason.join(' ')} ")
            rescue Discordrb::Errors::UnknownMessage
              event.respond('That message ID does not exist in this channel.')
            end
          else
            raise AgeBot::Execeptions::NotConfirmableError.new(event)
          end
        end
      end
    end
  end
end
