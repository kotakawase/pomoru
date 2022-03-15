# frozen_string_literal: true

require 'discordrb'
require_relative '../../session/countdown'
require_relative '../../session/reminder'
require_relative '../../session/session'
require_relative '../../session/session_controller'
require_relative '../../session/session_manager'
require_relative '../../session/session_messenger'
require_relative '../../settings'

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
          session.message.edit(GREETINGS.sample.to_s, MessageBuilder.status_embed(session))
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
        session.message.edit(GREETINGS.sample.to_s, MessageBuilder.status_embed(session))
        event.send_message('Turning off reminder alerts.')
      end
    end

    command :volume do |event, volume = nil|
      session = SessionManager.get_session(event)
      if session
        if volume.nil?
          event.send_message("Volume is now #{event.voice.filter_volume}/2.")
          return
        end
        volume = volume == '0.5' ? volume.to_f : volume.to_i
        if volume >= 3
          event.send_message('Use a number between 0 and 2.')
          return
        end
        event.voice.filter_volume = volume
        event.send_message("Changed the volume to #{volume}/2.")
      end
    end
  end
end
