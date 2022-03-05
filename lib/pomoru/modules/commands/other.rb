# frozen_string_literal: true

require 'discordrb'
require_relative '../../session/session_manager'
require_relative '../../session/session'
require_relative '../../session/settings'
require_relative '../../session/countdown'

module Bot::Commands
  module Other
    extend Discordrb::Commands::CommandContainer

    command :countdown do |event, duration = nil, title = 'Countdown'|
      session = SessionManager::ACTIVE_SESSIONS[SessionManager.session_id_from(event)]
      if session
        event.send_message('There is an active session running.')
        return
      end
      session = Session.new(
        state: State::COUNTDOWN,
        set: Settings.new(duration),
        ctx: event.content
      )
      # Countdown.handle_connection(event)
      SessionManager.activate(event, session)
      embed = Discordrb::Webhooks::Embed.new(
        title: title,
        description: "#{Timer.time_remaining(session)} left!"
      )
      session.message = event.send_embed('', embed)
      Countdown.start(event, session)
    end

    # command :remind do |event|
    # end

    # command :remind_off do |event|
    # end

    # command :volume do |event|
    # end
  end
end
