# frozen_string_literal: true

require 'discordrb'
require_relative '../config/user_messages'
require_relative '../session/countdown'
require_relative '../session/reminder'
require_relative '../session/session_activation'
require_relative '../session/session_fetcher'
require_relative '../session/session_manipulation'
require_relative '../session/session_messenger'
require_relative '../session/session'
require_relative '../message_builder'
require_relative '../state'
require_relative '../timer_setting'

module Bot::Commands
  module Other
    extend Discordrb::Commands::CommandContainer

    command :countdown do |event, duration = nil, title = 'Countdown'|
      session = SessionActivation::ACTIVE_SESSIONS[SessionActivation.session_id_from(event)]
      if session
        event.send_message(ACTIVE_SESSION_EXISTS_ERR)
        return
      end
      if duration.nil?
        event.send_message(MISSING_ARG_ERR)
        return
      elsif TimerSetting.invalid?(duration)
        event.send_message(NUM_OUTSIDE_ONE_AND_MAX_INTERVAL_ERR)
        return
      end

      session = Session.new(
        state: State::COUNTDOWN,
        set: TimerSetting.new(duration),
        ctx: event
      )
      SessionActivation.activate(session)
      SessionMessenger.send_countdown_msg(session, title)
      Countdown.start(session)
    end

    command :remind do |event, pomodoro, short_break, long_break|
      session = SessionFetcher.current_session(event)
      return if Countdown.running?(session)

      if session
        if pomodoro.nil? && session.reminder.running
          SessionMessenger.send_remind_msg(session)
          return
        else
          SessionManipulation.remind(session, Reminder.new(
                                                pomodoro,
                                                short_break,
                                                long_break
                                              ))
          session.reminder.running = true
          session.message.edit('', MessageBuilder.status_template(session))
          SessionMessenger.send_remind_msg(session)
          SessionManipulation.resume(session)
        end
      end
    end

    command :remind_off do |event|
      session = SessionFetcher.current_session(event)
      return if Countdown.running?(session)

      if session
        reminder = session.reminder
        unless reminder.running
          event.send_message('リマインダーは既にOffになっています')
          return
        end
        reminder.running = false
        session.message.edit('', MessageBuilder.status_template(session))
        event.send_message('リマインダーをOffにしました')
      end
    end

    command :volume do |event, volume = nil|
      session = SessionFetcher.current_session(event)
      return if Countdown.running?(session)

      if session
        if volume.nil?
          event.send_message("今の音量は#{event.voice.filter_volume}/2です")
          return
        end
        volume = volume == '0.5' ? volume.to_f : volume.to_i
        if volume >= 3
          event.send_message('0〜2までのパラメータを入力してください')
          return
        end
        event.voice.filter_volume = volume
        event.send_message("音量を#{volume}/2に変更しました")
      end
    end
  end
end
