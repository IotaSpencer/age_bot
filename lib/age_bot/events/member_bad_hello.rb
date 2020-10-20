# frozen_string_literal: true

module AgeBot
  module Bot
    module DiscordEvents
      module MemberBadHello
        extend Discordrb::EventContainer
        message do |event|
          if event.channel.name =~ /hello/
            # #hello has been sent a message
            if AgeBot::Helpers::Discord.parse_mention(event.content, event.server, event: event)&.name =~ /\#hello/
              # message was '#hello' or mention of #hello
              user = event.author
              begin
                user.pm(<<~HERE)
                  Hello, #{user.name}, in order to post or read #{event.server.name} messages you must be a certain role as well as submitted a form of ID with the server in question.
                  For #{event.server.name} that role is **#{event.server.role(AgeBot::Configs::ServerDB.db.servers[event.server.id.to_s].role).name}**
                  To do so, please send me a picture of your ID with everything but your 'date of birth' blacked out along with some sort of Discord™ proof (Your account page with the email blacked out or a handwritten Discord™ tag 
                    
                    For you that would be `#{event.user.distinct}`
                    When you do so, attach this message to the picture as a caption
                    `#{AgeBot::Configs::BotConfig.config.bot.prefix}verify #{event.server.id}`

                  You are receiving this message because you messaged ##{event.channel.name} a message that triggered me.
                  Your message will now be deleted since the message holds no purpose in ##{event.channel.name}.

                  You may ask questions about the process in ##{event.channel.name} but other than that, non-complying questions or messages will be deleted.
                HERE
              rescue Discordrb::Errors::NoPermission
                Logger.debug "I've received a NoPermission Error, either I'm blocked or something weird is going on."
              end
              event.channel.delete_message(event.message.id)
            elsif event.content =~ /^[Hh][Ee][Ll][Ll][Oo]$/
              # message was 'hello' or a variation on that
              user = event.author
              begin
              user.pm(<<~HERE)
                  Hello, #{user.name}, in order to post or read #{event.server.name} messages you must be a certain role as well as submitted a form of ID with the server in question.
                  For #{event.server.name} that role is **#{event.server.role(AgeBot::Configs::ServerDB.db.servers[event.server.id.to_s].role).name}**
                  To do so, please send me a picture of your ID with everything but your 'date of birth' blacked out along with some sort of Discord™ proof (Your account page with the email blacked out or a handwritten Discord™ tag 
                    
                    For you that would be `#{event.user.distinct}`
                    When you do so, attach this message to the picture as a caption
                    `#{AgeBot::Configs::BotConfig.config.bot.prefix}verify #{event.server.id}`

                  You are receiving this message because you messaged #{event.channel.name} a message that triggered me.
                  Your message will now be deleted since the message holds no purpose in #{event.channel.name}.

                  You may ask questions about the process in #{event.channel.name} but other than that, non-complying questions or messages will be deleted.
                HERE
                event.channel.delete_message(event.message.id)
              rescue Discordrb::Errors::NoPermission
                Logger.debug "I've received a NoPermission Error, either I'm blocked or something weird is going on."
              end
            end
          end
        end
      end
    end
  end
end
