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
    timer&.to_i
  end

  def self.invalid?(event, *timers)
    hantei = 0
    timers.each do |timer|
      hantei += 1 unless MAX_INTERVAL_MINUTES >= timer.to_i && (timer.to_i.positive? || timer.nil?)
    end

    if hantei.positive?
      event.send_message("Use durations between 1 and #{MAX_INTERVAL_MINUTES} minutes.")
      true
    else
      false
    end
  end
end
