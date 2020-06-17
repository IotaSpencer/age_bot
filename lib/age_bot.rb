require 'tty-config'
module AgeBot
  class Config
    attr_reader :config

    def initialize
      @config = TTY::Config.new
      @config.filename = 'config'
      @config.extname = '.yml'
      @config.prepend_path Pathname.new(Dir.home).join('.age_bot')
    end
  end
  class ServerDB
    attr_reader :db

    def initialize
      @db = TTY::Config.new
      @db.filename = 'db'
      @db.extname = '.yml'
      @db.prepend_path Pathname.new(Dir.home).join('.age_bot')
    end
    def write
      if @config.exist?
        @config.write(Pathname.new(Dir.home).join('.age_bot'))
      else
        @config.write(Pathname.new(Dir.home).join('.age_bot'), force: true)
      end
    end
  end
end
require 'age_bot/version'