class Settings
  attr_reader :pomodoro, :short_break, :long_break, :intervals

  def initialize(*timer)
    @pomodoro = timer[0].to_i
    @short_break = timer[1].to_i
    @long_break = timer[2].to_i
    @intervals = timer[3].to_i
  end
end
