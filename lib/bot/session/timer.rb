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
    def set_time_remaining(session)
      if session.state == State::SHORT_BREAK
        delay = session.settings.short_break * 60
      elsif session.state == State::LONG_BREAK
        delay = session.settings.long_break * 60
      else
        delay = session.settings.pomodoro * 60
      end
      session.timer.remaining = delay
      session.timer.end = Time.now + delay
    end

    def time_remaining_to_str
      # 後でやる
    end
  end
end
