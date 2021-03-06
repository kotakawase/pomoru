# frozen_string_literal: true

require_relative 'config/help'

class MessageBuilder
  class << self
    def status_template(session, colour: nil)
      colour ||= 0x2ecc71
      state = session.state.capitalize
      status = session.timer.running ? 'Running' : 'Pausing'
      reminder = session.reminder.running ? 'On' : 'Off'
      autoshush = session.autoshush.all ? 'On' : 'Off'
      status_str = <<~TEXT
        Current intervals: #{state}
        Status: #{status}
        Reminder alerts: #{reminder}
        Autoshush: #{autoshush}
      TEXT
      create_embed('Timer', status_str, colour)
    end

    def settings_template(session)
      settings = session.settings
      settings_str = <<~TEXT
        Pomodoro: #{settings.pomodoro} min
        Short break: #{settings.short_break} min
        Long break: #{settings.long_break} min
        Interbals: #{settings.intervals}
      TEXT
      colour = 0xFF8000

      create_embed('Session settings', settings_str, colour)
    end

    def stats_template(stats)
      "#{stats.pomos_completed} pomodoro (#{stats.minutes_completed}分) 完了しました"
    end

    def help_template(command)
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
        nil
      end
    end

    def countdown_template(session, title, colour: nil)
      colour ||= 0x1abc9c
      if session == 'DONE'
        create_embed(title, session, colour)
      else
        create_embed(title, session.timer.time_remaining_to_str(session), colour)
      end
    end

    def reminder_template(session)
      reminders = session.reminder
      pomo_txt = molding_reminder_txt(reminders.pomodoro)
      short_txt = molding_reminder_txt(reminders.short_break)
      long_txt = molding_reminder_txt(reminders.long_break)
      reminders_str = <<~TEXT
        Pomodoro: #{pomo_txt}
        Short break: #{short_txt}
        Long break: #{long_txt}
      TEXT
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
