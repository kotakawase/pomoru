require_relative './timer_base'

class Break < TimerBase
  SHORT_MINUTES = 5
  LONG_MINUTES = 15

  def initialize(type:)
    minutes = case type
              when :short
                SHORT_MINUTES
              when :long
                LONG_MINUTES
              end
    super(minutes: minutes)
  end
end
