require 'discordrb'
module AgeBot
  module Bot
    module DiscordCommands
      class Misc
        HELPERS = AgeBot::Bot::Helpers
        extend Discordrb::Commands::CommandContainer
        command(:ping) do |event, *code|
          if event.user.id == AgeBot::Configs::BotConfig.config.bot.owner.to_i
            begin
              event.respond("Pong! #{eval(code)}")
            rescue StandardError => e
              event.respond("Pong! (Code has errored, see logs)")
              AgeBot::Logger.error(<<~ERROR)
                #{e.class}
                #{e.full_message}
                #{e.backtrace}
              ERROR
            end
          elsif event.user.id == AgeBot::Configs::BotConfig.config.bot.owner.to_i and code.empty?
            event.respond("Pong!")
          else
            event.respond("Pong!")
          end
        end
      end
    end
  end
end