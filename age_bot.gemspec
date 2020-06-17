# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'age_bot/version'

Gem::Specification.new do |s|
  s.name          = 'age_bot'
  s.version       = AgeBot::VERSION
  s.authors       = ['IotaSpencer']
  s.email         = ['me@iotaspencer.me']
  s.homepage      = 'https://github.com/IotaSpencer/age_bot'
  s.licenses      = ['MIT']
  s.summary       = 'discord bot to verify ages of users by sending id\'s to moderator channel'
  s.description   = 'A discord bot that sends ID pictures of users to a moderator channel'

  s.files         = Dir.glob('{bin/*,lib/**/*,[A-Z]*}')
  s.executables   = Dir.glob('bin/*').map { |f| File.basename(f) }

  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
end
