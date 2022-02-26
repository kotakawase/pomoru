# frozen_string_literal: true

class Timer
  attr_writer :running
  attr_accessor :end, :remaining

  def initialize(set)
    @duration = set.pomodoro * 60
    @set = set
    @running = false
    @remaining = @duration
    @end = Time.now + @duration
  end

  class << self
    def remaining_time_update(session)
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

    def time_remaining_to_str
      # 後でやる
    end
  end
end
