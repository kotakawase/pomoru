# frozen_string_literal: true

require_relative './state'
require_relative './timer'

class StateHandler
  class << self
    def transition(session)
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
      session.timer.time_remaining_update(session)
      session.state
    end
  end
end
