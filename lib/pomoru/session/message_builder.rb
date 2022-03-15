# frozen_string_literal: true

module MessageBuilder
  module_function

  def status_embed(_session)
    status_str = "Current intervals: Pomodoro\n \
      Status: Running\n \
      Reminder alerts: Off\n \
      Autoshush: Off"

    Discordrb::Webhooks::Embed.new(
      title: 'Timer',
      description: status_str
    )
  end

  def settings_embed(session)
    settings = session.settings
    settings_str = "Pomodoro: #{settings.pomodoro} min\n \
      Short break: #{settings.short_break} min\n \
      Long break: #{settings.long_break} min\n \
      Interbals: #{settings.intervals}"

    Discordrb::Webhooks::Embed.new(
      title: 'Session settings',
      description: settings_str
    )
  end

  def stats_msg(stats)
    "You completed #{stats.pomos_completed} pomodoro (#{stats.minutes_completed}minutes)"
  end

  def reminders_embed(session)
    reminders = session.reminder
    pomo_txt = molding_reminder_txt(reminders.pomodoro)
    short_txt = molding_reminder_txt(reminders.short_break)
    long_txt = molding_reminder_txt(reminders.long_break)
    reminders_str = "Pomodoro: #{pomo_txt}\n \
      Short break: #{short_txt}\n \
      Long break: #{long_txt}"

    Discordrb::Webhooks::Embed.new(
      title: 'Reminder alerts',
      description: reminders_str
    )
  end

  def molding_reminder_txt(reminder)
    if reminder == 'None'
      reminder.to_s
    else
      "#{reminder} min"
    end
  end

  private_class_method :molding_reminder_txt
end
