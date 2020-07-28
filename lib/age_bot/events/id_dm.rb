# frozen_string_literal: true

module AgeBot
  module Bot
    module DiscordEvents
      module IDDM
        extend Discordrb::EventContainer
        pm do |event|
          if !event.message.attachments.empty?
            case
            when event.message.content.start_with?("#{AgeBot::Configs::BotConfig.config.bot.prefix}verify")
              user    = event.user
              msg_obj = event.message.content.split(' ')
              file    = event.message.attachments[0]
              msg     = msg_obj
              puts 'running verification on input for sanity'
              puts "Checking #{event.message.content.split(' ')[1]} in ServerDB"
              server_id = msg_obj[1]
              begin
                db           = AgeBot::Configs::ServerDB.db
                channel      = AgeBot::Bot.bot.channel(db.servers[server_id].id_channel)
                server       = AgeBot::Bot.bot.server(msg_obj[1])
                member       = server.member(user.id, true)
                sent_msg_obj = channel.send_message <<~HERE
                  #{file.url}
                  To add the 'Adult' role to this user, enter the following:
                  `#{AgeBot::Configs::BotConfig.config.bot.prefix}confirm $XXXXX$ "#{event.user.distinct}"`

                  Sent as of #{event.timestamp} UTC

                  To reject this user use the message ID and a reasonable reason--

                  `#{AgeBot::Configs::BotConfig.config.bot.prefix}reject $XXXXX$ "#{event.user.distinct}" "username is photoshopped in"`
                  or 
                  `#{AgeBot::Configs::BotConfig.config.bot.prefix}reject $XXXXX$ "#{event.user.distinct}" "user is not 18+"`

                  This reason will be sent to this user. So be nice and concise.
                HERE
                sent_msg_obj.edit(sent_msg_obj.content.gsub('$XXXXX$', "#{sent_msg_obj.id}"))
                user.pm("Your submission has been sent.")
              rescue StandardError
                event.respond("A bug has occured, please let my owner know (owner of https://discord.gg/nBB7K5y)")
              ensure
                user.pm("If you haven't received a message that your submission has been sent, let the admins of the applicable server know to contact the owner of this bot.")
              end

            else
              event.user.pm(<<~VERIFY)
                Verifications are done using #{AgeBot::Configs::BotConfig.config.bot.prefix}verify <server id>"
              VERIFY
            end
          else
            puts <<~HERE
              -----------------------------------------------
              Message from #{event.user.id}(#{event.user.distinct}) — #{event.timestamp}
              "#{event.message.content}"

              -----------------------------------------------
            HERE
          end
        end
      end
    end
  end
end
