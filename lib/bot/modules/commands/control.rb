# frozen_string_literal: true

require 'discordrb'
require_relative '../../session/session'
require_relative '../../session/state'
require_relative '../../session/settings'
require_relative '../../session/session_controller'

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
      channel = event.user.voice_channel
      if channel
        event.bot.voice_destroy(event.server.id)
        event.send_message('Good Bye!')
        # next 'Good Bye!'
      else
        event.send_message('Can not disconnect')
      end
    end

    # command :edit do |event|
    # end
  end
end
