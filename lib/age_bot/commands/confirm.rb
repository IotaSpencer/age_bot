require 'age_bot/exceptions/not_owner_error'
require 'age_bot/helpers'
module AgeBot
  module Bot
    module DiscordCommands
      # Confirm the age using a command
      module ConfirmAge
        HELPERS = AgeBot::Bot::Helpers
        extend Discordrb::Commands::CommandContainer
        command(:hello, {
            help_available: false,
            description:    "Get a message telling you to verify for a certain role.",
            usage:          "#{AgeBot::Configs::BotConfig.config.bot.prefix}hello"
        }) do |event|
          user = event.user
          event.message.react('👋')
          event.message.react('🇭')
          event.message.react('🇮')
          sleep(5)
          user.pm(<<~HERE)
            Hello, #{user.name}, in order to post or read #{event.server.name} messages you must be a certain role as well as submitted a form of ID with the server in question.
            For #{event.server.name} that role is **#{event.server.role(AgeBot::Configs::ServerDB.db.servers[event.server.id.to_s].role).name}**
            To do so, please send me a picture of your ID with everything but your 'date of birth' blacked out along with some sort of Discord™ proof (Your account page with the email blacked out or a handwritten Discord™ tag 
              
              For you that would be `#{event.user.distinct}`
              When you do so, attach this message to the picture as a caption
              `#{AgeBot::Configs::BotConfig.config.bot.prefix}verify #{event.server.id}`
          HERE
          sleep(5)
          event.message.delete
        end
        command(:confirm, {
            help_available: false,
            min_args:       2,
            description:    "Confirm a user to be a certain verifiable role.",
            usage:          "#{AgeBot::Configs::BotConfig.config.bot.prefix}confirm <message_id> <NAME#0000>"}) do |event, message_id, user|
          admin        = event.server.member(event.user.id)
          user_name    = user.split('#')[0]
          user_discrim = user.split('#')[1]
          event.server.request_chunks(event.server.id.to_s)
          user_id = event.bot.find_user(user_name, user_discrim).id
          member  = event.server.member(user_id)
          if HELPERS.can_confirm?(admin)
            if member.role?(AgeBot::Configs::ServerDB.db.servers[member.server.id.to_s].role)
              event.respond("#{member.distinct} already has the required role '#{event.server.role(AgeBot::Configs::ServerDB.db.servers[event.server.id.to_s].role).name}'")
            else
              member.add_role(AgeBot::Configs::ServerDB.db.servers[member.server.id.to_s].role)
              event.channel.delete_message(message_id)
              event.respond("#{member.distinct} was confirmed to be a(n) #{event.server.role(AgeBot::Configs::ServerDB.db.servers[event.server.id.to_s].role).name}")
            end
          else
            raise AgeBot::Execeptions::NotConfirmableError.new(event)
          end
        end

        command(:reject, {
            help_available: false,
            min_args:       3,
            description:    "Reject that a user is eligible for the certain role based on a reason",
            usage:          "#{AgeBot::Configs::BotConfig.config.bot.prefix}reject <message_id> <\"NAME#0000\"> <\"reason...\">"}) do |event, message_id, user, *reason|
          admin                   = event.server.member(event.author.id)
          user_name, user_discrim = *user.split('#')
          event.bot.request_chunks(event.server.id.to_s)
          user = AgeBot::Bot::Helpers.member_from_tag(event.server, user)
          if HELPERS.can_confirm?(admin)
            channel = event.channel
            begin
              event.bot.channel(event.channel).delete_message(message_id.to_s)
              channel.send_message("#{user.distinct} was rejected on grounds of \"#{reason.join(' ')}\"")
              user.pm("Your submission was rejected due to the reason — #{reason.join(' ')} ")
            rescue Discordrb::Errors::UnknownMessage
              event.respond('That message ID does not exist in this channel.')
            end
          else
            raise AgeBot::Execeptions::NotConfirmableError.new(event)
          end
        end
        command(:chunks, {
            help_available: true,
            max_args:       0,
            description:    "Request member chunks for the current server",
            usage:          "#{AgeBot::Configs::BotConfig.config.bot.prefix}chunks"}) do |event|
          admin = event.server.member(event.author.id)
          if HELPERS.can_confirm?(admin)
            event.bot.request_chunks(event.server.id)
          else
            raise AgeBot::Execeptions::NotConfirmableError.new(event)
          end
        end
      end
    end
  end
end
