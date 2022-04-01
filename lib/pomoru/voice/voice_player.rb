# frozen_string_literal: true

require_relative '../state'

class VoicePlayer
  POMO_START = "#{Dir.pwd}/sounds/pomodoro_start.mp3".freeze
  POMO_END = "#{Dir.pwd}/sounds/pomodoro_end.mp3".freeze
  REMIND_ALERT = "#{Dir.pwd}/sounds/remind_start.mp3".freeze

  class << self
    def alert(session, value = nil)
      if value.nil? || (value == session.timer.end && session.state != State::POMODORO)
        path = POMO_START # start and pomodoro
      elsif value == session.timer.end && session.state == State::POMODORO
        path = POMO_END # short break and long break
      elsif value == session.reminder.end
        path = REMIND_ALERT # remind
      end
      init_alert_thread(session, path)
    end

    private

    def init_alert_thread(session, path)
      Thread.new { session.event.voice.play_file(path) }
    end
  end
end
