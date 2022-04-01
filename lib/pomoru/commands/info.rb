# frozen_string_literal: true

require 'discordrb'
require_relative '../session/countdown'
require_relative '../session/session_manager'
require_relative '../message_builder'
require_relative '../state'

module Bot::Commands
  module Info
    extend Discordrb::Commands::CommandContainer

    command :help do |event, command = nil|
      help_embed = MessageBuilder.help_embed(command)
      if help_embed
        event.send_embed('', help_embed)
      else
        event.send_message('有効なコマンドを入力してください')
      end
    end

    command :status do |event|
      session = SessionManager.get_session(event)
      return if Countdown.running?(session)
      if session
        session.message.edit('', MessageBuilder.status_embed(session, colour: 0xff0000))
        session.message.unpin
        status_embed = MessageBuilder.status_embed(session)
        session.message = session.event.send_embed('', status_embed)
        session.message.pin
        event.send_message(session.timer.time_remaining(session))
      end
    end

    command :stats do |event|
      session = SessionManager.get_session(event)
      return if Countdown.running?(session)
      if session
        stats = session.stats
        if stats.pomos_completed.positive?
          event.send_message(MessageBuilder.stats_msg(session.stats))
        else
          event.send_message('まだポモドーロは完了していません')
        end
      end
    end

    command :settings do |event|
      session = SessionManager.get_session(event)
      return if Countdown.running?(session)
      event.send_embed('', MessageBuilder.settings_embed(session)) if session
      event.send_embed('', MessageBuilder.reminders_embed(session)) if session.reminder.running
    end

    command :servers do |event|
      event.send_message("ポモるは、#{event.bot.servers.count}サーバーで使用されています")
    end
  end
end
