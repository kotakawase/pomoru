# frozen_string_literal: true

require 'discordrb'
require_relative '../../session/session'
require_relative '../../session/state'
require_relative '../../session/settings'
require_relative '../../session/session_controller'
require_relative '../../session/session_manager'
require_relative '../../session/timer'

module Bot::Commands
  module Control
    extend Discordrb::Commands::CommandContainer

    command :start do |event, pomodoro = 25, short_break = 5, long_break = 15, intervals = 4|
      session = Session.new(
        state: State::POMODORO,
        set: Settings.new(
          pomodoro,
          short_break,
          long_break,
          intervals
        ),
        ctx: event.content
      )
      SessionController.start(event, session)
    end

    command :pause do |event|
      session = SessionManager.get_session(event)
      timer = session.timer
      if session
        unless timer.running
          event.send_message('Timer is already paused.')
          return
        end
        timer.running = false
        timer.remaining = timer.end.to_i - Time.now.to_i
        event.send_message("Pausing #{session.state}.")
      end
    end

    command :resume do |event|
      session = SessionManager.get_session(event)
      timer = session.timer
      if session
        if session.timer.running
          event.send_message('Timer is already running.')
          return
        end
        timer.running = true
        timer.end = Time.now + timer.remaining
        event.send_message("Resuming #{session.state}.")
        SessionController.resume(event, session)
      end
    end

    command :restart do |event|
      session = SessionManager.get_session(event)
      if session
        Timer.time_remaining_update(session)
        event.send_message("Restarting #{session.state}.")
        SessionController.resume(event, session)
      end
    end

    command :skip do |event|
      session = SessionManager.get_session(event)
      stats = session.stats
      if session
        if stats.pomos_completed >= 0 && session.state == State::POMODORO
          stats.pomos_completed -= 1
          stats.minutes_completed -= session.settings.pomodoro
        end
        event.send_message("Skipping #{session.state}.")
        StateHandler.transition(event, session)
        SessionController.resume(event, session)
      end
    end

    command :end do |event|
      session = SessionManager.get_session(event)
      if session
        if session.stats.pomos_completed.positive?
          event.send_message('Great job!')
        else
          event.send_message('See you again soon!')
        end
      end
      SessionController.end(event, session)
    end

    command :edit do |event, pomodoro = nil, short_break = nil, long_break = nil, intervals = nil|
      session = SessionManager.get_session(event)
      if session
        SessionController.edit(event, session, Settings.new(
                                                 pomodoro,
                                                 short_break,
                                                 long_break,
                                                 intervals
                                               ))
        Timer.time_remaining_update(session)
        SessionController.resume(event, session)
      end
    end
  end
end
