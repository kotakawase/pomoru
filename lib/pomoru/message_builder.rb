# frozen_string_literal: true

require_relative './config/help'

class MessageBuilder
  class << self
    def status_embed(session)
      state = session.state.capitalize
      status = session.timer.running ? 'Running' : 'Pausing'
      reminder = session.reminder.running ? 'On' : 'Off'
      autoshush = session.autoshush.all ? 'On' : 'Off'
      status_str = "Current intervals: #{state}\n \
        Status: #{status}\n \
        Reminder alerts: #{reminder}\n \
        Autoshush: #{autoshush}"

      create_embed('Timer', status_str)
    end

    def settings_embed(session)
      settings = session.settings
      settings_str = "Pomodoro: #{settings.pomodoro} min\n \
        Short break: #{settings.short_break} min\n \
        Long break: #{settings.long_break} min\n \
        Interbals: #{settings.intervals}"

      create_embed('Session settings', settings_str)
    end

    def stats_msg(stats)
      "You completed #{stats.pomos_completed} pomodoro (#{stats.minutes_completed}minutes)"
    end

    def help_embed(command)
      if command.nil?
        embed = create_embed('Help menu', SUMMARY)
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

          embed = create_embed(cmd_info[:command], cmd_info[:use])
          return embed
        end
      end
    end

    def countdown_embed(session, title)
      if session == 'DONE'
        create_embed(title, session)
      else
        create_embed(title, "#{session.timer.time_remaining(session)} left!")
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

      create_embed('Reminder alerts', reminders_str)
    end

    private

    def molding_reminder_txt(reminder)
      if reminder == 'None'
        reminder.to_s
      else
        "#{reminder} min"
      end
    end

    def create_embed(title, description)
      Discordrb::Webhooks::Embed.new(
        title:,
        description:
      )
    end
  end
end
