# frozen_string_literal: true

require 'age_bot/logger'
module AgeBot
  module Bot
    module DiscordEvents
      module HCNI
        extend Discordrb::EventContainer
        message do |event|
          user_tag = event.user.distinct
          user = event.user
          msg_obj = event.message.content.split(' ')
          msg = msg_obj
          channel = event.bot.parse_mention(msg, event.server&.id ? event.server.id : nil) || nil

          case msg
          when /^(!hello|& hello)(.*)?/

            dm_indi = event.server.nil?
            if dm_indi == true
              event.respond("Its &hello in #hello\nOn the server you have in common with me, if you haven't already done this before for that server.")
            else
              event.respond("#{user.mention}: Its &hello in #hello, nothing else.")
            end
            sleep(60)
            event.message.delete
          when /^([!&@$]verify)(.*)/
            channel = event.channel
            dm_indi = event.server.nil?
            if dm_indi == true
              nil
            else
              event.respond("#{user.mention}: You do that in a private message to the bot, not to this channel.")
              !event.message.attachments.empty? ? event.respond("Also do not send your ID+tag to this public channel") : nil
            end
            when !channel.nil?
          end
        end
      end
    end
  end
end
