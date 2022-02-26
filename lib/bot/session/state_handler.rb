class StateHandler
  class << self
    def transition(event, session)
      session.timer.running = false
      if session.state == State::POMODORO
        stats = session.stats
        stats.pomos_completed += 1
        stats.minutes_completed += session.settings.pomodoro
        if stats.pomos_completed > 0 && stats.pomos_completed % session.settings.intervals == 0
          session.state = State::LONG_BREAK
        else
          session.state = State::SHORT_BREAK
        end
      else
        session.state = State::POMODORO
      end
      Timer.set_time_remaining(session)
      event.send_message("Starting #{session.state}")
    end
  end
end
