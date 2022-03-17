# frozen_string_literal: true

require_relative './config/help'

module MessageBuilder
  module_function

  def status_embed(session)
    state = session.state.capitalize
    status = session.timer.running ? 'Running' : 'Pausing'
    reminder = session.reminder.running ? 'On' : 'Off'
    autoshush = session.autoshush.all ? 'On' : 'Off'
    status_str = "Current intervals: #{state}\n \
      Status: #{status}\n \
      Reminder alerts: #{reminder}\n \
      Autoshush: #{autoshush}"

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

  def help_embed(command)
    if command.nil?
      embed = Discordrb::Webhooks::Embed.new(
        title: 'Help menu',
        description: SUMMARY
      )
      COMMANDS.each do |key, value|
        values = ''
        value.values.each do |v|
          values += "#{v[:command]}\n"
        end
        embed.add_field(
          name: key,
          value: "```\n#{values}```",
          inline: false
        )
      end
      return embed
    else
      COMMANDS.each do |key, value|
        cmd_info = value[command.intern]
        if cmd_info
          embed = Discordrb::Webhooks::Embed.new(
            title: cmd_info[:command],
            description: cmd_info[:use]
          )
          return embed
        end
      end
    end
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
