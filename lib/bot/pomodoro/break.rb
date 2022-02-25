# frozen_string_literal: true

require_relative './timer_base'

class Break < TimerBase
  def initialize(minutes)
    super(minutes)
  end
end
