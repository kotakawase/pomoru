# frozen_string_literal: true

require 'discordrb'
require_relative '../../session/session_manager'
require_relative '../../session/message_builder'

module Bot::Commands
  module Info
    extend Discordrb::Commands::CommandContainer

    # command :help do |event|
    # end

    command :status do |event|
      session = SessionManager.get_session(event)
      if session
        event.send_embed('', MessageBuilder.status_embed(session))
        event.send_message(Timer.time_remaining(session).to_s)
      end
    end

    command :stats do |event|
      session = SessionManager.get_session(event)
      if session
        stats = session.stats
        if stats.pomos_completed.positive?
          event.send_message(MessageBuilder.stats_msg(session.stats))
        else
          event.send_message('You haven\'t completed any pomodoros yet.')
        end
      end
    end

    command :settings do |event|
      session = SessionManager.get_session(event)
      event.send_embed('', MessageBuilder.settings_embed(session)) if session
      event.send_embed('', MessageBuilder.reminders_embed(session)) if session.reminder.running
    end

    command :servers do |event|
      event.send_message("pomoru is in #{event.bot.servers.count} servers.")
    end
  end
end
