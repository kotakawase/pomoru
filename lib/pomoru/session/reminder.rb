require_relative './state'
require_relative './session_manager'

class Reminder
  attr_reader :pomodoro, :short_break, :long_break, :end, :time_executed
  attr_accessor :running

  POMO_REMIND = 5
  SHORT_REMIND = 1
  LONG_REMIND = 5

  def initialize(*timers)
    @pomodoro = to_i(timers[0])
    @short_break = to_i(timers[1])
    @long_break = to_i(timers[2])
    @running = false
    @end = nil
    @time_executed = Time.now
    @next_remind = nil
  end

  def to_i(timer)
    timer&.to_i
  end

  def start(session)
    loop do
      break unless run(session)
    end
  end

  def run(session)
    @running = true
    if @next_remind.nil?
      caculate_current_remind(session)
    end
    time_executed = @time_executed
    reminder_end = @end
    if @end > Time.now
      remind_remaining = @end.to_i - Time.now.to_i
      sleep remind_remaining
      return false unless reminder_latest?(session, time_executed, reminder_end)

      session.event.send_message("#{(session.timer.end.to_i - Time.now.to_i) / 60} minute left until end of #{session.state}!")
      # session.event.voice.play_file()
    end
    time_remaining = session.timer.end.to_i - Time.now.to_i
    sleep time_remaining
    return false unless reminder_latest?(session, time_executed, reminder_end)

    remind_transition(session)
  end

  private

  def caculate_current_remind(session)
    @end = case session.state
           when State::SHORT_BREAK
             session.timer.end - @short_break.to_i * 60
           when State::LONG_BREAK
             session.timer.end - @long_break.to_i * 60
           else
             session.timer.end - @pomodoro.to_i * 60
           end
  end

  def reminder_latest?(session, time_executed, reminder_end)
    session = SessionManager::ACTIVE_SESSIONS[SessionManager.session_id_from(session.event)]
    session&.timer&.running && reminder_end == session.reminder.end && time_executed == session.reminder.time_executed
  end

  def remind_transition(session)
    if session.state == State::POMODORO
      stats = session.stats
      @next_remind = if stats.pomos_completed.positive? && (stats.pomos_completed % session.settings.intervals).zero?
                       @long_break
                     else
                       @short_break
                     end
    else
      @next_remind = @pomodoro
    end
    remind_update(session)
  end

  def remind_update(session)
    @end = case @next_remind
           when @short_break
             (Time.now + (session.settings.short_break * 60)) - @short_break.to_i * 60
           when @long_break
             (Time.now + (session.settings.long_break * 60)) - @long_break.to_i * 60
           else
             (Time.now + (session.settings.pomodoro * 60)) - @pomodoro.to_i * 60
           end
  end
end
