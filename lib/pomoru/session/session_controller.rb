# frozen_string_literal: true

require_relative './reminder'
require_relative './session'
require_relative './session_manager'
require_relative './session_messenger'
require_relative '../voice/voice_accessor'
require_relative '../voice/voice_manager'
require_relative '../voice/voice_player'
require_relative '../settings'
require_relative '../state_handler'

class SessionController
  class << self
    def start(session)
      return unless VoiceManager.connect(session)

      VoicePlayer.alert(session)
      SessionManager.activate(session)
      SessionMessenger.send_start_msg(session)
      loop do
        break unless run(session)
      end
    end

    def end(session)
      session.message.edit('', MessageBuilder.status_embed(session, colour: 0xff0000)) unless session.state == State::COUNTDOWN
      session.message.unpin
      SessionManager.deactivate(session)
      VoiceManager.disconnect(session) if VoiceAccessor.get_voice_client(session)
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
        Reminder.automatically_update_reminders(session, new_settings.pomodoro, short_break, long_break, intervals)
        session.reminder.running = true
      end
      session.settings
    end

    def remind(session, new_reminder)
      pomodoro_reminder = new_reminder.pomodoro || session.reminder.pomodoro
      short_break_reminder = new_reminder.short_break || session.reminder.short_break
      long_break_reminder = new_reminder.long_break || session.reminder.long_break
      Reminder.automatically_update_reminders(session, pomodoro_reminder.to_i, short_break_reminder.to_i, long_break_reminder.to_i)
    end

    private

    def run(session)
      timer_end = session.timer.end
      if session.reminder.running
        return false unless session.reminder.run(session)
      else
        sleep session.timer.remaining
        return false unless latest_session?(session, timer_end)
      end
      return false if SessionManager.kill_if_thread(session)

      VoicePlayer.alert(session, timer_end)
      StateHandler.transition(session)
      session.message.edit(GREETINGS.sample.to_s, MessageBuilder.status_embed(session))
      session.event.send_message("Starting #{session.state}")
    end

    def latest_session?(session, timer_end)
      session = SessionManager::ACTIVE_SESSIONS[SessionManager.session_id_from(session.event)]
      session&.timer&.running && timer_end == session.timer.end && !session.reminder.running
    end
  end
end
