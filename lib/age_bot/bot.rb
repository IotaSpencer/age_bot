require 'discordrb'
require 'age_bot/scheduler'
module AgeBot
  module Bot

    attr_reader :bot
    prefix_proc = proc do |message|
      # Extract the first word and the rest of the message,
      # and ignore the message if it doesn't start with "!":
      match = /^&(\w+)(.*)/.match(message.content)
      if match
        first = match[1]
        rest = match[2]
        # Return the modified string with the first word lowercase:
        "#{first.downcase}#{rest}"
      end
    end
    @bot = Discordrb::Commands::CommandBot.new(
      token: AgeBot::Configs::BotConfig.config.bot.token,
      prefix: prefix_proc,
      fancy_log: true,
      log_mode: :verbose,
      advanced_functionality: true
    )
    # Discord commands
    module DiscordCommands
      ;
    end

    Dir['lib/age_bot/commands/*.rb'].each do |file|
      load file

      @bot.debug "Loaded Command file: #{file}"
    end
    DiscordCommands.constants.each do |file|
      @bot.debug "Included Command file #{file}"
      @bot.include! DiscordCommands.const_get file
    end

    # Discord events
    module DiscordEvents
      ;
    end

    Dir['lib/age_bot/events/*.rb'].each do |file|
      load file
      @bot.debug "Loaded Event file: #{file}"
    end
    DiscordEvents.constants.each do |file|
      @bot.include! DiscordEvents.const_get file
      @bot.debug "Included Event file #{file}"
    end

    module_function

    def self.start
      @bot.run
    rescue Interrupt
      @bot.stop
    end

    def self.stop
      @bot.stop
    end

    def shutdown
      @bot.stop
    end

    def self.bot
      @bot
    end
  end
end
