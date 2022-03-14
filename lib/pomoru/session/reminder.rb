require_relative './state'
require_relative './session_manager'

class Reminder
  attr_reader :pomodoro, :short_break, :long_break, :end, :time_executed
  attr_accessor :running

  POMO_REMIND = 5
  SHORT_REMIND = 1
  LONG_REMIND = 5

  def initialize(*timers)
    @pomodoro = timers[0]
    @short_break = timers[1]
    @long_break = timers[2]
    @running = false
    @end = nil
    @time_executed = Time.now
  end

  def run(session)
    caculate_current_remind(session)
    time_executed = @time_executed
    reminder_end = @end
    if !(session.timer.end == @end) && @end > Time.now
      remind_remaining = @end.to_i - Time.now.to_i
      sleep remind_remaining
      return false unless reminder_latest?(session, time_executed, reminder_end)

      session.event.send_message("#{(session.timer.end.to_i - Time.now.to_i) / 60} minute left until end of #{session.state}!")
      # session.event.voice.play_file()
    end
    time_remaining = session.timer.end.to_i - Time.now.to_i
    sleep time_remaining
    return false unless reminder_latest?(session, time_executed, reminder_end)

    return true
  end

  private

  def to_i(timer)
    timer&.to_i
  end

  def caculate_current_remind(session)
    @end = case session.state
           when State::SHORT_BREAK
             session.timer.end - to_i(@short_break) * 60
           when State::LONG_BREAK
             session.timer.end - to_i(@long_break) * 60
           else
             session.timer.end - to_i(@pomodoro) * 60
           end
  end

  def reminder_latest?(session, time_executed, reminder_end)
    session = SessionManager::ACTIVE_SESSIONS[SessionManager.session_id_from(session.event)]
    reminder = session.reminder
    session&.timer&.running && reminder_end == reminder.end && time_executed == reminder.time_executed && reminder.running
  end
end
