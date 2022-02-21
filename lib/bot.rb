# frozen_string_literal: true

require 'discordrb'
require 'dotenv/load'

module Bot
  TOKEN = ENV['TOKEN']
  CLIENT_ID = ENV['CLIENT_ID']
  PREFIX = ENV['PREFIX']
  BOT = Discordrb::Commands::CommandBot.new(
    token: TOKEN,
    client_id: CLIENT_ID,
    prefix: PREFIX,
    help_command: false
  )

  def self.load_modules(cls, path)
    new_module = Module.new
    const_set(cls.to_sym, new_module)
    Dir["lib/bot/modules/#{path}/*rb"].each { |file| load file }
    new_module.constants.each do |mod|
      BOT.include! new_module.const_get(mod)
    end
  end

  load_modules(:Commands, 'commands')
  load_modules(:Events, 'events')

  BOT.run :async
  puts 'Bot is running!'
  BOT.sync
end
