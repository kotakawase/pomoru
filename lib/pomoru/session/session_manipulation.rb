# frozen_string_literal: true

require_relative './reminder'
require_relative './session_activation'
require_relative './session_fetcher'
require_relative './session_messenger'
require_relative '../voice/voice_accessor'
require_relative '../voice/voice_connection'
require_relative '../voice/voice_player'
require_relative '../message_builder'
require_relative '../state_handler'
require_relative '../state'
require_relative '../timer_setting'

class SessionManipulation
  class << self
    def start(session)
      return unless VoiceConnection.connect(session)

      VoicePlayer.alert(session)
      SessionActivation.activate(session)
      SessionMessenger.send_start_msg(session)
      loop do
        break unless run(session)
      end
    end

    def end(session)
      session.message.edit('', MessageBuilder.status_embed(session, colour: 0xff0000)) unless session.state == State::COUNTDOWN
      session.message.unpin
      SessionActivation.deactivate(session)
      VoiceConnection.disconnect(session) if VoiceAccessor.voice_client(session)
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
      session.settings = TimerSetting.new(new_settings.pomodoro, short_break, long_break, intervals)
      if session.reminder.running
        Reminder.automatically_update(session, new_settings.pomodoro, short_break, long_break, intervals)
        session.reminder.running = true
      end
      session.settings
    end

    def remind(session, new_reminder)
      pomodoro_reminder = new_reminder.pomodoro || session.reminder.pomodoro
      short_break_reminder = new_reminder.short_break || session.reminder.short_break
      long_break_reminder = new_reminder.long_break || session.reminder.long_break
      Reminder.automatically_update(session, pomodoro_reminder.to_i, short_break_reminder.to_i, long_break_reminder.to_i)
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
      VoicePlayer.alert(session, timer_end)
      StateHandler.transition(session)
      session.message.edit('', MessageBuilder.status_embed(session))
      session.event.send_message("#{session.state}を始めます")
    end

    def latest_session?(session, timer_end)
      session = SessionActivation::ACTIVE_SESSIONS[SessionActivation.session_id_from(session.event)]
      session&.timer&.running && timer_end == session.timer.end && !session.reminder.running
    end
  end
end
