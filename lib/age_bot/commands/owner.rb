require 'age_bot/exceptions/not_owner_error'
module AgeBot
  module Bot
    module DiscordCommands
      module Owner
        extend Discordrb::Commands::CommandContainer
        command(:shutdown, help_available: false, aliases: [:k]) do |event|
          if event.user.id == AgeBot::Configs::BotConfig.config.bot.owner.to_i
            Logger.warn 'Shutting down.'
            event.respond ":skull:"
            event.bot.watching = "itself die..  💀"
            sleep(5)
          else
            raise AgeBot::Execeptions::NotOwnerError.new(event)
          end
          exit
        rescue
          event.respond ":negative_squared_cross_mark: | An error occurred"
        end

        # command(:restart, help_available: false, aliases: [:r]) do |event|
        #   begin
        #     if event.user.id == AgeBot::Configs::BotConfig.config.bot.owner
        #       event.respond ":white_check_mark:"
        #     else
        #       raise AgeBot::Exceptions::NotOwnerError
        #     end
        #     sleep 1
        #     exec('ruby gitcord.rb')
        #   rescue AgeBot::Exceptions::NotOwnerError.new(event)
        #     event.respond "No can do, you're not my owner."
        #   rescue
        #     event.respond ":negative_squared_cross_mark: | An error occurred"
        #   end
        # end

        command(:clear, help_available: false, min_args: 1, aliases: [:c]) do |event, count|
          if event.user.id == AgeBot::Configs::BotConfig.config.bot.owner.to_i
            c = count.to_i
            return "1:100" if c > 100
            event.channel.prune c, true
            puts "Deleted Messages"
          else
            raise AgeBot::Execeptions::NotOwnerError.new(event)
          end
        end
        command(:eval) do |event, *code|
          if event.user.id == AgeBot::Configs::BotConfig.config.bot.owner.to_i
            eval code.join(' ')
          else
            raise AgeBot::Execeptions::NotOwnerError.new(event)
          end
        end
      end
    end
  end
end
