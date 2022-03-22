# frozen_string_literal: true

require_relative '../config/user_messages'
require_relative '../message_builder'

module SessionMessenger
  module_function

  def send_start_msg(session)
    embed = MessageBuilder.status_embed(session)
    session.message = session.event.send_embed(GREETINGS.sample.to_s, embed)
    session.event.send_embed('', MessageBuilder.settings_embed(session))
    session.message.pin
  end

  def send_edit_msg(session)
    session.event.send_embed('Continuing pomodoro session with new settings!',
                             MessageBuilder.settings_embed(session))
  end

  def send_countdown_msg(session, title)
    embed = Discordrb::Webhooks::Embed.new(
      title:,
      description: "#{session.timer.time_remaining(session)} left!"
    )
    session.message = session.event.send_embed('', embed)
  end

  def send_remind_msg(session)
    reminders = session.reminder
    if reminders.pomodoro == 'None' && reminders.short_break == 'None' && reminders.long_break == 'None'
      session.event.send_message('All reminder times are 0.')
    else
      session.event.send_embed('Reminder alerts turned on.', MessageBuilder.reminders_embed(session))
    end
  end
end
