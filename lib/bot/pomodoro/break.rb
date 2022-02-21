require_relative './timer_base'

class Break < TimerBase
  def initialize(type:)
    minutes = case type
              when :short
                5
              when :long
                15
              end
    super(minutes: minutes)
  end
end
