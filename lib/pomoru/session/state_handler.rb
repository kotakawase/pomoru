# frozen_string_literal: true

class StateHandler
  class << self
    def transition(session)
      session.timer.running = false
      if session.state == State::POMODORO
        stats = session.stats
        stats.pomos_completed += 1
        stats.minutes_completed += session.settings.pomodoro
        session.state = if stats.pomos_completed.positive? && (stats.pomos_completed % session.settings.intervals).zero?
                          State::LONG_BREAK
                        else
                          State::SHORT_BREAK
                        end
      else
        session.state = State::POMODORO
      end
      Timer.time_remaining_update(session)
      session.event.send_message("Starting #{session.state}")
    end
  end
end
