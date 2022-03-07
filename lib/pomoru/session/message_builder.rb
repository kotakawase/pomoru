# frozen_string_literal: true

module MessageBuilder
  module_function

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
end
