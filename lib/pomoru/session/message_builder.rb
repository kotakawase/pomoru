def settings_embed(session)
  settings = session.settings
  settings_str = "Pomodoro: #{settings.pomodoro}min\n \
    Short break: #{settings.short_break}min\n \
    Long break: #{settings.long_break}min\n \
    Interbals: #{settings.intervals}"

  embed = Discordrb::Webhooks::Embed.new(
    title: 'Session settings',
    description: settings_str
  )
  embed
end

def stats_msg(stats)
  msg = "You completed #{stats.pomos_completed} pomodoro (#{stats.minutes_completed}minutes)"
  msg
end
