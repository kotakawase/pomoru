require_relative './timer_base'

class Pomodoro < TimerBase
  MINUTES = 25

  def initialize(minutes: MINUTES)
    super
  end
end
