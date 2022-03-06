require_relative './user_messages'
require_relative './message_builder'

def send_start_msg(session)
  session.event.send_embed("#{GREETINGS.sample}", settings_embed(session))
end

def send_edit_msg(session)
  session.event.send_embed('Continuing pomodoro session with new settings!',
                           settings_embed(session))
end

def send_countdown_msg(session, title)
  embed = Discordrb::Webhooks::Embed.new(
    title: title,
    description: "#{Timer.time_remaining(session)} left!"
  )
  session.message = session.event.send_embed('', embed)
end
