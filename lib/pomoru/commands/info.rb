# frozen_string_literal: true

require 'discordrb'
require_relative '../session/countdown'
require_relative '../session/session_fetcher'
require_relative '../message_builder'
require_relative '../state'

module Bot::Commands
  module Info
    extend Discordrb::Commands::CommandContainer

    command :help do |event, command = nil|
      embed = MessageBuilder.help_template(command)
      if embed
        event.send_embed('', embed)
      else
        event.send_message('有効なコマンドを入力してください')
      end
    end

    command :status do |event|
      session = SessionFetcher.current_session(event)
      return if Countdown.running?(session)

      if session
        session.message.edit('', MessageBuilder.status_template(session, colour: 0xff0000))
        session.message.unpin
        session.message = session.event.send_embed('', MessageBuilder.status_template(session))
        session.message.pin
        event.send_message(session.timer.time_remaining_to_str(session))
      end
    end

    command :stats do |event|
      session = SessionFetcher.current_session(event)
      return if Countdown.running?(session)

      if session
        stats = session.stats
        if stats.pomos_completed.positive?
          event.send_message(MessageBuilder.stats_template(session.stats))
        else
          event.send_message('まだポモドーロは完了していません')
        end
      end
    end

    command :settings do |event|
      session = SessionFetcher.current_session(event)
      return if Countdown.running?(session)

      event.send_embed('', MessageBuilder.settings_template(session)) if session
      event.send_embed('', MessageBuilder.reminder_template(session)) if session.reminder.running
    end

    command :servers do |event|
      event.send_message("ポモるは、#{event.bot.servers.count}サーバーで使用されています")
    end
  end
end
