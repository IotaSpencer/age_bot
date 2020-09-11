# frozen_string_literal: true
require 'age_bot/logger'
module AgeBot
  module Bot
    module DiscordEvents
      module IDDM
        extend Discordrb::EventContainer
        pm do |event|
          user_tag = event.user.distinct
          user     = event.user
          msg_obj  = event.message.content.split(' ')
          msg      = msg_obj

          if event.message.content.start_with?("#{AgeBot::Configs::BotConfig.config.bot.prefix}verify")
            if event.message.attachments.empty?
              # User didn't send a file
              # Tell us what they said
              Logger.info <<~MESSAGE
                -----------------------------------------------
                    Message from #{event.user.id}(#{event.user.distinct}) — #{event.timestamp}
                "#{event.message.content}"
                -----------------------------------------------
              MESSAGE
            elsif event.message.attachments.length == 1
              file = event.message.attachments[0]
              Logger.info("running sanity checks on #{user.distinct}")
              server_id = msg[1]
              begin
                Logger.debug 'loading DB'
                db = AgeBot::Configs::ServerDB.db
                Logger.debug 'loaded DB'
                Logger.debug "Trying to find server for #{msg_obj[1]}"
                server = AgeBot::Bot.bot.server(msg_obj[1])
                Logger.debug "Found server. '#{server.name}' ID: #{server.id}"
                Logger.debug "Trying to find verification channel to send to."
                channel = AgeBot::Bot.bot.channel(db.servers[server_id].id_channel)
                Logger.debug "Found channel. '#{channel.name}'"
                Logger.debug "Trying to find member object on '#{server.name}' for '#{user_tag}'"
                member = server.member(user.id, true)
                Logger.debug "Found member. '#{member.nick}' on server '#{server.name}'"
                sent_msg_obj = channel.send_message <<~HERE
                  #{file.url}
                  To add the 'Adult' role to this user, enter the following:
                  `#{AgeBot::Configs::BotConfig.config.bot.prefix}confirm $XXXXX$ "#{event.user.distinct}"`

                  Sent as of #{event.timestamp} UTC

                  To reject this user use the message ID and a reasonable reason--

                  `#{AgeBot::Configs::BotConfig.config.bot.prefix}reject $XXXXX$ "#{event.user.distinct}" "username is photoshopped in"`
                  or 
                  `#{AgeBot::Configs::BotConfig.config.bot.prefix}reject $XXXXX$ "#{event.user.distinct}" "user is not 18+"`
                  or
                  `#{AgeBot::Configs::BotConfig.config.bot.prefix}reject $XXXXX$ "#{event.user.distinct}" "XXXXX is needed as well as XXXXX in the same shot"`
                  or 
                  `#{AgeBot::Configs::BotConfig.config.bot.prefix}reject $XXXXX$ "#{event.user.distinct}" "XXXXX is needed see #id-example"`

                  The given reason will be sent to the user. So be nice and concise.
                HERE
                sent_msg_obj.edit(sent_msg_obj.content.gsub('$XXXXX$', "#{sent_msg_obj.id}"))
                Logger.info "#{user.distinct} has sent what appears to be a verification."
                user.pm("Your submission has been sent.")
              rescue StandardError => e
                event.respond("An exception has occured, please let my owner know (iotaspencer#0001)")
              ensure
                Logger.debug 'Covering our backside'
                user.pm("If you haven't received a message that your submission has been sent, let the admins of the applicable server know to contact the owner of this bot.")
              end

            elsif event.message.attachments.length > 1
              event.user.pm(<<~HELLO)
                Hi, you're trying to send more than one photograph to me at a time.
                Please only send one shot to me,
                using the examples in the channel possibly called '#id-example'
                

                If you're **not** sending more than one photograph, this may be a bug.
                If that's the case, please let my owner (iotaspencer#0001) know.

              HELLO
            end
          else
            Logger.info <<~MESSAGE
              -----------------------------------------------
              Message from #{event.user.id}(#{event.user.distinct}) — #{event.timestamp}
              "#{event.message.content}"
              -----------------------------------------------
            MESSAGE
          end
        end
      end
    end
  end
end
