# frozen_string_literal: true

module AgeBot
  module Bot
    module DiscordEvents
      module IDDM
        extend Discordrb::EventContainer
        pm do |event|
          case
          when event.message.content.start_with?('$verify')
            user    = event.user
            msg_obj = event.message.content.split(' ')
            file    = event.message.attachments[0]
            msg     = msgobj
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
                `$confirm $XXXXX$ #{event.user.distinct}`

                Sent as of #{event.timestamp} UTC

                To reject this user use the message ID and a reasonable reason--

                `$reject $XXXXX$ "#{event.user.distinct}" "username is photoshopped in"`
                or 
                `$reject $XXXXX$ "#{event.user.distinct}" "user is not 18+"`

                This reason will be sent to this user. So be nice and concise.
              HERE
              sent_msg_obj.edit(sent_msg_obj.content.gsub('$XXXXX$', "#{sent_msg_obj.id}"))
            rescue StandardError
              event.respond("A bug has occured, please let my owner (")
            end

          else
            # itchy hack
          end
        end
      end
    end
  end
end
