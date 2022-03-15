# frozen_string_literal: true

class Timer
  attr_accessor :running, :end, :remaining

  def initialize(set)
    @duration = set.pomodoro * 60
    @running = false
    @remaining = @duration
    @end = Time.now + @duration
  end

  class << self
    def time_remaining_update(session)
      delay = case session.state
              when State::SHORT_BREAK
                session.settings.short_break * 60
              when State::LONG_BREAK
                session.settings.long_break * 60
              else
                session.settings.pomodoro * 60
              end
      session.timer.remaining = delay
      session.timer.end = Time.now + delay
    end

    def time_remaining(session)
      time_remaining = if session.timer.running
                         session.timer.end.to_i - Time.now.to_i
                       else
                         session.timer.remaining.to_i
                       end
      remaining_minites = time_remaining / 60
      remaining_seconds = format('%02d', time_remaining - (remaining_minites * 60))
      "#{remaining_minites}minutes #{remaining_seconds}seconds remining on #{session.state}!"
    end
  end
end
