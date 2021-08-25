require 'age_bot/exceptions/not_owner_error'
module AgeBot
  module Bot
    module DiscordCommands
      module Owner
        HELPERS = AgeBot::Bot::Helpers
        DHELPERS = AgeBot::Helpers::Discord
        extend Discordrb::Commands::CommandContainer
        command(:servers) do |event|
          servers = event.bot.servers
          embeds = DHELPERS.make_server_embeds(servers)
          embeds.each do |embed|
            event.respond('', false, embed)
          end
        end
        command(:shutdown, help_available: false, aliases: [:k]) do |event|
          if event.user.id == AgeBot::Configs::BotConfig.config.bot.owner.to_i
            Logger.warn 'Shutting down.'
            event.respond ":skull:"
            event.bot.watching = "itself die..  💀"
            sleep(5)
          else
            raise AgeBot::Execeptions::NotOwnerError.new(event)
          end
          event.bot.stop
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
            if code.join(' ').start_with?('```ruby') and code.join(' ').end_with?('```') # Check for code style
              code_string = event.content.gsub("```ruby", '').gsub("```", '')
              eval code_string
            elsif event.message.attachments.length == 1 and event.message.attachments.first.filename =~ /[A-Za-z0-9\-_]+\.rb/ # Eval a rb file
              code_file = HELPERS.open_uri(event.message.attachments.first.url)
              eval(code_file)
            elsif event.message.attachments.length > 1 # Files attached should be <= 1
              event.respond("Only 1 file is to be attached.")
            else
              # If all else fails just try and eval the text given
              eval code.join(' ')
            end

          else
            raise AgeBot::Execeptions::NotOwnerError.new(event)
          end
        end
      end
    end
  end
end
