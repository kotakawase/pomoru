# frozen_string_literal: true

require_relative './reminder'
require_relative './session'
require_relative './session_manager'
require_relative './session_messenger'
require_relative '../settings'
require_relative '../state_handler'

class SessionController
  class << self
    def start(session)
      channel = session.event.user.voice_channel
      session.event.bot.voice_connect(channel)
      SessionManager.activate(session)
      SessionMessenger.send_start_msg(session)
      # session.event.voice.play_file()
      loop do
        break unless run(session)
      end
    end

    def end(session)
      SessionManager.deactivate(session)
      session.message.unpin
      session.event.bot.voice_destroy(session.event.server.id)
    end

    def resume(session)
      loop do
        break unless run(session)
      end
    end

    def edit(session, new_settings)
      short_break = new_settings.short_break || session.settings.short_break
      long_break = new_settings.long_break || session.settings.long_break
      intervals = new_settings.intervals || session.settings.intervals
      session.settings = Settings.new(new_settings.pomodoro, short_break, long_break, intervals)
      SessionMessenger.send_edit_msg(session)
      return unless session.reminder.running

      # ポモドーロタイマーがリマインドの時間より小さい時間でeditされた場合は自動で最小値に変換する
      reminders = session.reminder
      pomodoro_reminder = convert_pomodoro_timer_reminders(new_settings.pomodoro, reminders.pomodoro.to_i, Reminder::POMO_REMIND)
      short_break_reminder = convert_pomodoro_timer_reminders_for_editing(short_break, reminders.short_break.to_i)
      long_break_reminder = convert_pomodoro_timer_reminders(long_break, reminders.long_break.to_i, Reminder::LONG_REMIND)
      session.reminder = Reminder.new(pomodoro_reminder, short_break_reminder, long_break_reminder)
      session.reminder.running = true
      SessionMessenger.send_remind_msg(session)
    end

    def remind(session, new_reminder)
      pomodoro_reminder = new_reminder.pomodoro || session.reminder.pomodoro
      short_break_reminder = new_reminder.short_break || session.reminder.short_break
      long_break_reminder = new_reminder.long_break || session.reminder.long_break

      # ポモドーロタイマーがデフォルトのリマインドの時間より小さい場合は自動で最小値に変換する
      settings = session.settings
      pomodoro_reminder = convert_pomodoro_timer_reminders(settings.pomodoro, pomodoro_reminder.to_i, Reminder::POMO_REMIND)
      short_break_reminder = convert_pomodoro_timer_reminders(settings.short_break, short_break_reminder.to_i, Reminder::SHORT_REMIND)
      long_break_reminder = convert_pomodoro_timer_reminders(settings.long_break, long_break_reminder.to_i, Reminder::LONG_REMIND)
      session.reminder = Reminder.new(pomodoro_reminder, short_break_reminder, long_break_reminder)
      SessionMessenger.send_remind_msg(session)
    end

    private

    def run(session)
      if session.reminder.running
        return false unless session.reminder.run(session)
      else
        timer_end = session.timer.end
        sleep session.timer.remaining
        session = SessionManager::ACTIVE_SESSIONS[SessionManager.session_id_from(session.event)]
        return false unless latest_session?(session, timer_end)
      end
      # event.voice.play_file()
      StateHandler.transition(session)
      session.message.edit(GREETINGS.sample.to_s, MessageBuilder.status_embed(session))
      session.event.send_message("Starting #{session.state}")
    end

    def latest_session?(session, timer_end)
      session&.timer&.running && timer_end == session.timer.end && !session.reminder.running
    end

    def convert_pomodoro_timer_reminders(setting, remind, value)
      if (setting < value && setting <= remind) || remind.zero?
        'None'
      elsif setting <= remind
        1
      elsif setting > remind
        remind
      end
    end

    def convert_pomodoro_timer_reminders_for_editing(setting, remind)
      if setting == Reminder::SHORT_REMIND || setting <= remind || remind.zero?
        'None'
      else
        remind
      end
    end
  end
end
