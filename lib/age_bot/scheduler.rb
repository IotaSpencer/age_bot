require 'rufus-scheduler'

module AgeBot

  module Bot

    class Scheduler
      @scheduler = Rufus::Scheduler.new

      def self.scheduler
        @scheduler
      end
    end
  end
end 