# frozen_string_literal: true

require_relative './reminder'
require_relative './session'
require_relative './session_manager'
require_relative './session_messenger'
require_relative '../voice/voice_accessor'
require_relative '../voice/voice_manager'
require_relative '../settings'
require_relative '../state_handler'

class SessionController
  class << self
    def start(session)
      return unless VoiceManager.connect(session)
      SessionManager.activate(session)
      SessionMessenger.send_start_msg(session)
      # session.event.voice.play_file()
      loop do
        break unless run(session)
      end
    end

    def end(session)
      session.message.unpin
      SessionManager.deactivate(session)
      if VoiceAccessor.get_voice_client(session)
        VoiceManager.disconnect(session)
      end
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
      if session.reminder.running
        Reminder.automatically_update_reminders_after_editing(session, short_break, long_break, new_settings)
      else
        session.settings
      end
    end

    def remind(session, new_reminder)
      pomodoro_reminder = new_reminder.pomodoro || session.reminder.pomodoro
      short_break_reminder = new_reminder.short_break || session.reminder.short_break
      long_break_reminder = new_reminder.long_break || session.reminder.long_break

      # ポモドーロタイマーがデフォルトのリマインドの時間より小さい場合は自動で最小値に変換する
      settings = session.settings
      pomodoro_reminder = Reminder.convert_pomodoro_timer_reminders(settings.pomodoro, pomodoro_reminder.to_i, Reminder::POMO_REMIND)
      short_break_reminder = Reminder.convert_pomodoro_timer_reminders(settings.short_break, short_break_reminder.to_i, Reminder::SHORT_REMIND)
      long_break_reminder = Reminder.convert_pomodoro_timer_reminders(settings.long_break, long_break_reminder.to_i, Reminder::LONG_REMIND)
      session.reminder = Reminder.new(pomodoro_reminder, short_break_reminder, long_break_reminder)
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
      return false if SessionManager.kill_if_thread(session)
      # event.voice.play_file()
      StateHandler.transition(session)
      session.message.edit(GREETINGS.sample.to_s, MessageBuilder.status_embed(session))
      session.event.send_message("Starting #{session.state}")
    end

    def latest_session?(session, timer_end)
      session&.timer&.running && timer_end == session.timer.end && !session.reminder.running
    end
  end
end
