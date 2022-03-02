# frozen_string_literal: true

require 'discordrb'
require_relative '../../session/session_manager'

module Bot::Commands
  module Info
    extend Discordrb::Commands::CommandContainer

    # command :help do |event|
    # end

    command :status do |event|
      session = SessionManager.get_session(event)
      event.send_message(Timer.time_remaining(session).to_s) if session
    end

    command :stats do |event|
      session = SessionManager.get_session(event)
      stats = session.stats
      if session
        if stats.pomos_completed > 0
          event.send_message("You completed #{stats.pomos_completed} pomodoro (#{stats.minutes_completed}minutes)")
        else
          event.send_message('You haven\'t completed any pomodoros yet.')
        end
      end
    end

    command :settings do |event|
      session = SessionManager.get_session(event)
      settings = session.settings
      if session
        event.send_embed do |embed|
          embed.title = 'Session settings'
          embed.description = "Pomodoro: #{settings.pomodoro}min\nShort break: #{settings.short_break}min\nLong break: #{settings.long_break}min\nInterbals: #{settings.intervals}"
        end
      end
    end

    command :servers do |event|
      event.send_message("pomoru is in #{event.bot.servers.count} servers.")
    end
  end
end
