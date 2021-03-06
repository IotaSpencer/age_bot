# frozen_string_literal: true

require 'age_bot/exceptions/not_owner_error'
require 'age_bot/helpers'
require 'age_bot/logger'
module AgeBot
  module Bot
    module DiscordCommands
      # Forcing commands
      module FCom
        extend Discordrb::Commands::CommandContainer
        command(:fhello, {
                  max_args: 1,
                  min_args: 1,
                  description: "Force a #{AgeBot::Configs::BotConfig.config.bot.prefix}hello on a user",
                  usage: "#{AgeBot::Configs::BotConfig.config.bot.prefix}fhello"
                }) do |event, username|
          Logger.debug 'Requesting Chunks'
          event.bot.request_chunks(event.server.id.to_s)
          Logger.debug 'Got Chunks'
          Logger.debug 'Parsing Tag'
          user = AgeBot::Helpers::Discord.member_from_tag(event.server, username)
          Logger.debug 'Tag parsed.'
          Logger.debug 'DM\'ing user'
          user.pm(<<~HEREDOC)
            Hello, #{user.name}, in order to post or read #{event.server.name} messages you must be a certain role as well as submitted a form of ID with the server in question.
            For #{event.server.name} that role is **#{event.server.role(AgeBot::Configs::ServerDB.db.servers[event.server.id.to_s].role).name}**
            To do so, please send me a picture of your ID with everything but your 'date of birth' blacked out along with some sort of Discord™ proof (Your account page with the email blacked out or a handwritten Discord™ tag 
            
            For you that would be `#{user.distinct}`
            When you do so, attach this message to the picture as a caption.
            `#{AgeBot::Configs::BotConfig.config.bot.prefix}verify #{event.server.id}`
          HEREDOC
          Logger.debug "DM'd user"
        end
      end
    end
  end
end
