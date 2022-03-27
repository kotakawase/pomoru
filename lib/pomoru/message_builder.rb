# frozen_string_literal: true

require_relative './config/help'

class MessageBuilder
  class << self
    def status_embed(session, colour: nil)
      colour ||= 0x2ecc71
      state = session.state.capitalize
      status = session.timer.running ? 'Running' : 'Pausing'
      reminder = session.reminder.running ? 'On' : 'Off'
      autoshush = session.autoshush.all ? 'On' : 'Off'
      status_str = "Current intervals: #{state}\n \
        Status: #{status}\n \
        Reminder alerts: #{reminder}\n \
        Autoshush: #{autoshush}"

      create_embed('Timer', status_str, colour)
    end

    def settings_embed(session)
      settings = session.settings
      settings_str = "Pomodoro: #{settings.pomodoro} min\n \
        Short break: #{settings.short_break} min\n \
        Long break: #{settings.long_break} min\n \
        Interbals: #{settings.intervals}"
      colour = 0xFF8000

      create_embed('Session settings', settings_str, colour)
    end

    def stats_msg(stats)
      "You completed #{stats.pomos_completed} pomodoro (#{stats.minutes_completed}minutes)"
    end

    def help_embed(command)
      colour = 0x3498db
      if command.nil?
        embed = create_embed('Help menu', SUMMARY, colour)
        COMMANDS.each do |key, value|
          values = ''
          value.each_value { |v| values += "#{v[:command]}\n" }
          embed.add_field(
            name: key,
            value: "```\n#{values}```",
            inline: false
          )
        end
        embed
      else
        COMMANDS.each_value do |value|
          cmd_info = value[command.intern]
          next unless cmd_info

          embed = create_embed(cmd_info[:command], cmd_info[:use], colour)
          return embed
        end
      end
    end

    def countdown_embed(session, title, colour: nil)
      colour ||= 0x1abc9c
      if session == 'DONE'
        create_embed(title, session, colour)
      else
        create_embed(title, "#{session.timer.time_remaining(session)} left!", colour)
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
      colour = 0xFEE75C

      create_embed('Reminder alerts', reminders_str, colour)
    end

    private

    def molding_reminder_txt(reminder)
      if reminder == 'None'
        reminder.to_s
      else
        "#{reminder} min"
      end
    end

    def create_embed(title, description, colour)
      Discordrb::Webhooks::Embed.new(
        title:,
        description:,
        colour:
      )
    end
  end
end
