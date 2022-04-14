# frozen_string_literal: true

class State
  POMODORO = 'pomodoro'
  SHORT_BREAK = 'short break'
  LONG_BREAK = 'long break'
  COUNTDOWN = 'countdown'

  def self.transition(session)
    if session.state == POMODORO
      stats = session.stats
      stats.pomos_completed += 1
      stats.minutes_completed += session.settings.pomodoro
      session.state = if stats.pomos_completed.positive? && (stats.pomos_completed % session.settings.intervals).zero?
                        LONG_BREAK
                      else
                        SHORT_BREAK
                      end
    else
      session.state = POMODORO
    end
    session.timer.time_remaining_update(session)
    session.state
  end
end
