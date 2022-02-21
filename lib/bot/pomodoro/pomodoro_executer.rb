require_relative './pomodoro'
require_relative './short_break'
require_relative './long_break'

class PomodoroExecuter
  def run
    loop do
      3.times do
        Pomodoro.new.run
        ShortBreak.new.run
      end
      Pomodoro.new.run
      LongBreak.new.run
    end
  end
end
