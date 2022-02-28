# frozen_string_literal: true

require 'discordrb'
require_relative '../../session/session_maneger'

module Bot::Commands
  module Info
    extend Discordrb::Commands::CommandContainer

    # command :help do |event|
    # end

    command :status do |event|
      session = SessionManeger.get_session(event)
      if session
        event.send_message("#{Timer.time_remaining(session)}")
      end
    end

    # command :stats do |event|
    # end

    # command :settings do |event|
    # end

    # command :servers do |event|
    # end
  end
end
