# frozen_string_literal: true
require 'open-uri'
require 'discordrb/webhooks/builder'

# Require all the helper files
require 'age_bot/helpers/audit_log_helper'
require 'age_bot/helpers/discord'

module AgeBot
  module Helpers
    # Discord Helper Methods
    class Discord

    end
  end
  module Bot
    # Bot Helper Methods
    class Helpers
      # Open a url/uri and read the contents
      # @param [String] url link to open and read
      # @return [String] the contents of url's file
      def self.open_uri(url)
        URI.parse(url) do |f|
          f.read
        end
      end
    end
  end
end
