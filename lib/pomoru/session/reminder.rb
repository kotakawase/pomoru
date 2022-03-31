# frozen_string_literal: true

require_relative './session_manager'
require_relative '../voice/voice_player'
require_relative '../state'

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
    if session.timer.end != @end && @end > Time.now
      remind_remaining = @end.to_i - Time.now.to_i
      sleep remind_remaining
      return false unless latest_reminder?(session, time_executed, reminder_end) && session.reminder.running

      VoicePlayer.alert(session, reminder_end)
      session.event.send_message("#{session.state}の終わりまで残り#{(session.timer.end.to_i - Time.now.to_i) / 60}分!")
    end
    time_remaining = session.timer.end.to_i - Time.now.to_i
    sleep time_remaining
    return false unless latest_reminder?(session, time_executed, reminder_end)

    true
  end

  class << self
    def automatically_update_reminders(session, pomodoro, short_break, long_break, intervals = nil)
      if intervals # 4
        reminders = session.reminder
        pomodoro_reminder = convert_pomodoro_timer_reminders(pomodoro, reminders.pomodoro.to_i)
        short_break_reminder = convert_pomodoro_timer_reminders_for_editing(short_break, reminders.short_break.to_i)
        long_break_reminder = convert_pomodoro_timer_reminders(long_break, reminders.long_break.to_i)
      else
        settings = session.settings
        pomodoro_reminder = convert_pomodoro_timer_reminders(settings.pomodoro, pomodoro)
        short_break_reminder = convert_pomodoro_timer_reminders_for_remaining(settings.short_break, short_break)
        long_break_reminder = convert_pomodoro_timer_reminders(settings.long_break, long_break)
      end
      session.reminder = Reminder.new(pomodoro_reminder, short_break_reminder, long_break_reminder)
    end

    private

    def convert_pomodoro_timer_reminders(setting, remind)
      if (setting < Reminder::POMO_REMIND && setting <= remind) || remind.zero?
        'None'
      elsif setting <= remind
        1
      elsif setting > remind
        remind
      end
    end

    def convert_pomodoro_timer_reminders_for_editing(setting, remind)
      if setting == Reminder::SHORT_REMIND || setting <= remind || remind.zero?
        'None'
      else
        remind
      end
    end

    def convert_pomodoro_timer_reminders_for_remaining(setting, remind)
      if setting == Reminder::SHORT_REMIND || (setting < 5 && setting == remind) || remind.zero?
        'None'
      elsif setting <= remind
        1
      elsif setting > remind
        remind
      end
    end
  end

  private

  def to_i(timer)
    timer&.to_i
  end

  def caculate_current_remind(session)
    @end = case session.state
           when State::SHORT_BREAK
             session.timer.end - (to_i(@short_break) * 60)
           when State::LONG_BREAK
             session.timer.end - (to_i(@long_break) * 60)
           else
             session.timer.end - (to_i(@pomodoro) * 60)
           end
  end

  def latest_reminder?(session, time_executed, reminder_end)
    session = SessionManager::ACTIVE_SESSIONS[SessionManager.session_id_from(session.event)]
    session&.timer&.running && reminder_end == session.reminder.end && time_executed == session.reminder.time_executed
  end
end
