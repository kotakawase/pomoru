require 'discordrb'
require 'dotenv/load'

bot = Discordrb::Bot.new token: ENV['token']

bot.message(with_text: 'Ping!') do |event|
  event.respond 'Pong!'
end

bot.run
