# frozen_string_literal: true

require 'timecop'

class TimerBase
  def initialize(minutes:)
    @end_time = Time.now + (minutes * 60)
  end

  def run
    while Time.now < @end_time
      sleep 1
      diff_seconds = @end_time.to_i - Time.now.to_i
      remaining_minites = diff_seconds / 60
      remaining_seconds = format('%02d', diff_seconds - (remaining_minites * 60))
      print "\r#{remaining_minites}:#{remaining_seconds}"
      Timecop.travel(@end_time) unless ENV['DEBUG'].nil?
    end
    puts
  end
end
