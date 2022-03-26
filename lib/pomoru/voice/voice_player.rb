class VoicePlayer
  POMO_START = "#{Dir.pwd}/sounds/pomodoro_start.mp3"
  POMO_END = "#{Dir.pwd}/sounds/pomodoro_end.mp3"
  REMIND_START = "#{Dir.pwd}/sounds/remind_start.mp3"

  class << self
    def alert(session, value = nil)
      return unless session.event.voice

      if value.nil? || (session.state == State::SHORT_BREAK || session.state == State::LONG_BREAK)
        path = POMO_START # timer start and pomodoro
      elsif value == session.timer.end
        path = POMO_END # short break and long break
      elsif value == session.reminder.end
        path = REMIND_START # remind
      end
      init_alert_thread(session, path)
    end

    def init_alert_thread(session, path)
      Thread.new { session.event.voice.play_file(path) }
    end
  end
end
