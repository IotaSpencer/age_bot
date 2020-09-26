require 'rufus-scheduler'
require 'ostruct'
module AgeBot

  module Bot
    # Instances of Rufus::Scheduler
    class Schedules
      @schedules = {}
      # @return [Hash<String => Rufus::Scheduler>]
      def self.schedules
        @schedules
      end

      # @return [Rufus::Scheduler]
      # @param [String,Symbol] name name of scheduler
      def self.[](name)
        @schedules.fetch(name, nil)
      end

      # Remove a scheduler from the 'list'
      # @param [String,Symbol] name name of scheduler
      def self.delete(name)
        @schedules.delete(name)
      end

      # Add a scheduler to the 'list'
      # @return [Rufus::Scheduler]
      # @param [String,Symbol] name name of scheduler
      def self.add(name)
        scheduler = Rufus::Scheduler.new
        @schedules.store(name, scheduler)
        scheduler
      end
    end
  end
end