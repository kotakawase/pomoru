# frozen_string_literal: true

require 'discordrb'
require_relative '../../session/session'
require_relative '../../session/state'
require_relative '../../session/settings'
require_relative '../../session/session_controller'
require_relative '../../session/session_manager'

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

    # command :pause do |event|
    # end

    # command :resume do |event|
    # end

    # command :restart do |event|
    # end

    # command :skip do |event|
    # end

    command :end do |event|
      session = SessionManager.get_session(event)
      if session
        if session.stats.pomos_completed.positive?
          event.send_message('Great job!')
        else
          event.send_message('See you again soon!')
        end
      end
      SessionController.end(event)
    end

    # command :edit do |event|
    # end
  end
end
