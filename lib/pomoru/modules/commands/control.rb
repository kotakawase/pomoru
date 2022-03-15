# frozen_string_literal: true

require 'discordrb'
require_relative '../../session/session'
require_relative '../../session/state'
require_relative '../../session/settings'
require_relative '../../session/session_controller'
require_relative '../../session/session_manager'
require_relative '../../session/message_builder'
require_relative '../../session/user_messages'
require_relative '../../session/timer'

module Bot::Commands
  module Control
    extend Discordrb::Commands::CommandContainer

    command :start do |event, pomodoro = 25, short_break = 5, long_break = 15, intervals = 4|
      return if Settings.invalid?(event, pomodoro, short_break, long_break, intervals)

      session = SessionManager::ACTIVE_SESSIONS[SessionManager.session_id_from(event)]
      if session
        event.send_message('There is already an active session on the server.')
        return
      end
      channel = event.user.voice_channel
      if channel.nil?
        event.send_message('Join a voice channel to use pomoru!')
        return
      end

      session = Session.new(
        state: State::POMODORO,
        set: Settings.new(
          pomodoro,
          short_break,
          long_break,
          intervals
        ),
        ctx: event
      )
      session.timer.running = true
      SessionController.start(session)
    end

    command :pause do |event|
      session = SessionManager.get_session(event)
      if session
        timer = session.timer
        unless timer.running
          event.send_message('Timer is already paused.')
          return
        end
        timer.running = false
        timer.remaining = timer.end.to_i - Time.now.to_i
        session.message.edit(GREETINGS.sample.to_s, MessageBuilder.status_embed(session))
        event.send_message("Pausing #{session.state}.")
      end
    end

    command :resume do |event|
      session = SessionManager.get_session(event)
      if session
        timer = session.timer
        if session.timer.running
          event.send_message('Timer is already running.')
          return
        end
        timer.running = true
        timer.end = Time.now + timer.remaining
        session.message.edit(GREETINGS.sample.to_s, MessageBuilder.status_embed(session))
        event.send_message("Resuming #{session.state}.")
        SessionController.resume(session)
      end
    end

    command :restart do |event|
      session = SessionManager.get_session(event)
      if session
        Timer.time_remaining_update(session)
        event.send_message("Restarting #{session.state}.")
        SessionController.resume(session)
      end
    end

    command :skip do |event|
      session = SessionManager.get_session(event)
      if session
        stats = session.stats
        if stats.pomos_completed >= 0 && session.state == State::POMODORO
          stats.pomos_completed -= 1
          stats.minutes_completed -= session.settings.pomodoro
        end
        event.send_message("Skipping #{session.state}.")
        StateHandler.transition(session)
        SessionController.resume(session)
      end
    end

    command :end do |event|
      session = SessionManager.get_session(event)
      if session
        if session.stats.pomos_completed.positive?
          event.send_message("Great job!#{MessageBuilder.stats_msg(session.stats)}")
        else
          event.send_message('See you again soon!')
        end
        SessionController.end(session)
      end
    end

    command :edit do |event, pomodoro = nil, short_break = nil, long_break = nil, intervals = nil|
      session = SessionManager.get_session(event)
      if session
        if pomodoro.nil?
          event.send_message(MISSING_ARG_ERR.to_s)
          return
        end
        return if Settings.invalid?(event, pomodoro, short_break, long_break, intervals)

        SessionController.edit(session, Settings.new(
                                          pomodoro,
                                          short_break,
                                          long_break,
                                          intervals
                                        ))
        Timer.time_remaining_update(session)
        SessionController.resume(session)
      end
    end
  end
end
