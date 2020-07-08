# frozen_string_literal: true

module AgeBot
  module Bot
    class Helpers
      # @param [Discordrb::Member] member a 'member' on a server
      def self.can_confirm?(member)
        results = []
        AgeBot::Configs::ServerDB.db.servers[member.server.id.to_s].can_confirm.each do |hsh|
          results << member.role?(hsh['id']) if member.server.role(hsh['id'])
        end
        results.any?
      end
    end
  end
end
