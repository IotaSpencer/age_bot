# frozen_string_literal: true

module AgeBot
  module Bot
    module DiscordEvents
      module IDDM
        extend Discordrb::EventContainer
        pm do |event|
          case
          when event.message.content.start_with?('$verify')
            msgobj = event.message.content.split(' ')
            file = event.message.attachments[0]
            msg = msgobj
            puts 'running verification on input for sanity'
            puts "Checking #{event.message.content.split(' ')[1]} in ServerDB"
            server = ''
            server_id = msgobj[1]
            db = AgeBot::Configs::ServerDB.db
            channel = AgeBot::Bot.bot.channel(db.servers[server_id].id_channel)
            server = AgeBot::Bot.bot.server(msgobj[1])
            sent_msg_obj = channel.send_message <<~HERE
              #{file.url}
              To add the 'Adult' role to this user, enter the following:
              `$confirm #{event.user.distinct} $XXXXX$`

              Sent as of #{event.timestamp} UTC

              To reject this user use the message ID and a reasonable reason--

              `$reject #{event.user.distinct} $XXXXX$ username is photoshopped in`
              or 
              `$reject #{event.user.distinct} $XXXXX$ user is not 18+`

              This reason will be sent to this user. So be nice and concise.
                HERE
            sent_msg_obj.edit(sent_msg_obj.content.gsub('$XXXXX$', "#{sent_msg_obj.id}"))

          else
            return
          end
        end
      end
    end
  end
end
