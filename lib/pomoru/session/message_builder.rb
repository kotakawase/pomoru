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
    reminders_str = "Pomodoro: #{reminders.pomodoro}min\n \
      Short break: #{reminders.short_break}min\n \
      Long break: #{reminders.long_break}min"

    Discordrb::Webhooks::Embed.new(
      title: 'Reminder alerts',
      description: reminders_str
    )
  end
end
