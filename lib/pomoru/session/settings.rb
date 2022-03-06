# frozen_string_literal: true

require_relative './config'

class Settings
  attr_reader :pomodoro, :short_break, :long_break, :intervals

  def initialize(*timers)
    @pomodoro = to_i(timers[0])
    @short_break = to_i(timers[1])
    @long_break = to_i(timers[2])
    @intervals = to_i(timers[3])
  end

  def to_i(timer)
    timer.to_i unless timer.nil?
  end

  def self.is_invalid?(event, *timers)
    if (MAX_INTERVAL_MINUTES >= timers[0].to_i && (timers[0].to_i > 0 || timers[0].nil?)) \
      && (MAX_INTERVAL_MINUTES >= timers[1].to_i && (timers[1].to_i > 0 || timers[1].nil?)) \
      && (MAX_INTERVAL_MINUTES >= timers[2].to_i && (timers[2].to_i > 0 || timers[2].nil?)) \
      && (MAX_INTERVAL_MINUTES >= timers[3].to_i && (timers[3].to_i > 0 || timers[3].nil?))
      return false
    else
      event.send_message("Use durations between 1 and #{MAX_INTERVAL_MINUTES} minutes.")
      return true
    end
  end
end
