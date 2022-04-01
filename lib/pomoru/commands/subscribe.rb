# frozen_string_literal: true

require 'discordrb'
require 'dotenv/load'
require_relative '../config/user_messages'
require_relative '../session/autoshush'
require_relative '../session/countdown'
require_relative '../session/session_manager'

module Bot::Commands
  module Subscribe
    extend Discordrb::Commands::CommandContainer

    command :autoshush do |event, who = ''|
      session = SessionManager.get_session(event)
      return if Countdown.running?(session)

      if session
        if event.user.voice_channel.nil?
          event.send_message("ボイスチャンネルに参加して#{ENV['PREFIX']}#{event.command.name}を実行してください")
          return
        end
        auto_shush = session.autoshush
        if who.downcase == AutoShush::ALL
          auto_shush.handle_all(session)
        else
          event.send_message(AUTOSHUSH_ARG_ERR)
          return
        end
      end
    end
  end
end
