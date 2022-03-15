# frozen_string_literal: true

require 'discordrb'
require_relative '../../session/session_manager'
require_relative '../../session/voice_accessor'
require_relative '../../session/autoshush'
require_relative '../../session/user_messages'

module Bot::Commands
  module Subscribe
    extend Discordrb::Commands::CommandContainer

    command :autoshush do |event, who = ''|
      session = SessionManager.get_session(event)
      if session
        unless VoiceAccessor.get_voice_channel(session)
          event.send_message('pomoru must be in a voice channel to use auto-shush.')
          return
        end
        auto_shush = session.autoshush
        if who.downcase == AutoShush::ALL
          auto_shush.handle_all(session)
        else
          event.send_message(AUTOSHUSH_ARG_ERR.to_s)
          return
        end
      end
    end
  end
end
