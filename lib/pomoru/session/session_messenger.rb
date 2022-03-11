# frozen_string_literal: true

require_relative './user_messages'
require_relative './message_builder'

module SessionMessenger
  module_function

  def send_start_msg(session)
    session.event.send_embed(GREETINGS.sample.to_s, MessageBuilder.status_embed(session))
    session.event.send_embed('', MessageBuilder.settings_embed(session))
  end

  def send_edit_msg(session)
    session.event.send_embed('Continuing pomodoro session with new settings!',
                             MessageBuilder.settings_embed(session))
  end

  def send_countdown_msg(session, title)
    embed = Discordrb::Webhooks::Embed.new(
      title:,
      description: "#{Timer.time_remaining(session)} left!"
    )
    session.message = session.event.send_embed('', embed)
  end

  def send_remind_msg(session)
    session.event.send_embed('Reminder alerts turned on.', MessageBuilder.reminders_embed(session))
  end
end
