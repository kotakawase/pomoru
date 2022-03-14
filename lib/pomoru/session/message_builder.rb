# frozen_string_literal: true

module MessageBuilder
  module_function

  def status_embed(session)
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
    settings_str = "Pomodoro: #{settings.pomodoro}min\n \
      Short break: #{settings.short_break}min\n \
      Long break: #{settings.long_break}min\n \
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
    pomo_txt = if reminders.pomodoro == "None"
      "#{reminders.pomodoro}"
    else
      "#{reminders.pomodoro}min"
    end
    short_txt = if reminders.short_break == "None"
      "#{reminders.short_break}"
    else
      "#{reminders.short_break}min"
    end
    long_txt = if reminders.long_break == "None"
      "#{reminders.long_break}"
    else
      "#{reminders.long_break}min"
    end
    reminders_str = "Pomodoro: #{pomo_txt}\n \
      Short break: #{short_txt}\n \
      Long break: #{long_txt}"

    Discordrb::Webhooks::Embed.new(
      title: 'Reminder alerts',
      description: reminders_str
    )
  end
end
