require 'discordrb'
require 'age_bot/scheduler'
module AgeBot
  module Bot

    attr_reader :bot

    @bot = Discordrb::Commands::CommandBot.new(
      token: AgeBot::Configs::BotConfig.config.bot.token,
      prefix: AgeBot::Configs::BotConfig.config.bot.prefix,
      fancy_log: true,
      log_mode: :normal,
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

    alias_method :shutdown, :stop

    def self.bot
      @bot
    end
  end
end
