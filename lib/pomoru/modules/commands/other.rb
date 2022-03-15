# frozen_string_literal: true

require 'discordrb'
require_relative '../../session/session_manager'
require_relative '../../session/session'
require_relative '../../session/settings'
require_relative '../../session/session_messenger'
require_relative '../../session/countdown'
require_relative '../../session/reminder'
require_relative '../../session/session_controller'

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
        ctx: event
      )
      # Countdown.handle_connection(event)
      SessionManager.activate(session)
      SessionMessenger.send_countdown_msg(session, title)
      Countdown.start(session)
    end

    command :remind do |event, pomodoro, short_break, long_break|
      session = SessionManager.get_session(event)
      if session
        if pomodoro.nil? && session.reminder.running
          SessionMessenger.send_remind_msg(session)
          return
        else
          SessionController.remind(session, Reminder.new(
                                              pomodoro,
                                              short_break,
                                              long_break
                                            ))
          session.reminder.running = true
          SessionController.resume(session)
        end
      end
    end

    command :remind_off do |event|
      session = SessionManager.get_session(event)
      if session
        reminder = session.reminder
        unless reminder.running
          event.send_message('Reminder alerts is already off.')
          return
        end
        reminder.running = false
        event.send_message('Turning off reminder alerts.')
      end
    end

    # command :volume do |event|
    # end
  end
end
