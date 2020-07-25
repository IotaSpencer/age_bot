module AgeBot
  module Bot
    module DiscordEvents
      module MemberJoin
        extend Discordrb::EventContainer
        member_join do |event|
          user = event.user
          user.pm(<<~HERE )
            Hello, #{user.name}, in order to post or read #{event.server.name} messages you must be a certain role as well as submitted a form of ID with the server in question.
            For #{event.server.name} that role is **#{event.server.role(AgeBot::Configs::ServerDB.db.servers[event.server.id.to_s].role).name}**
            To do so, please send me a picture of your ID with everything but your 'date of birth' blacked out along with some sort of Discord™ proof (Your account page with the email blacked out or a handwritten Discord™ tag 
              
              For you that would be `#{event.user.distinct}`
              When you do so, attach this message to the picture as a caption
              `#{AgeBot::Configs::BotConfig.config.bot.prefix}verify #{event.server.id}`
          HERE
        end
      end
    end
  end
end
