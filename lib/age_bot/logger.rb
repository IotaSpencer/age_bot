require 'yell'
require 'json'
require 'paint'
require 'pathname'
require 'fileutils'
module AgeBot
  class Logger
    @cfg_dir  = Pathname.new(Dir.home).join('.age_bot')
    @log_path = @cfg_dir.join('logs')
    @logger   = Yell.new(trace: true) do |l|
      l.level = Yell.level.gte(:info)
      l.adapter(STDOUT, level: Yell.level.lte(:fatal), format: "[%d] %l %f:%n — %m")
      l.adapter(:datefile, "#{@log_path}/production.log", level: Yell.level.lte(:warn), format: "[%d] [%L] %f:%n — %m")
      l.adapter(:datefile, "#{@log_path}/error.log", level: Yell.level.gte(:error), format: "[%d] [%L] %f:%n — %m")
    end


    %i[debug info warn error fatal].each do |m|
      Logger.define_singleton_method m do |msg|
        Logger.instance_variable_get(:@logger).send(m, msg)
      end
    end
  end
end
