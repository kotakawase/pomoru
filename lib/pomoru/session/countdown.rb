# frozen_string_literal: true

require 'discordrb'
require_relative './session_controller'
require_relative './session_manager'

class Countdown
  class << self
    # def handle_connection(event)
    #   channel = event.user.voice_channel
    #   if channel.nil?
    #     event.send_message("ボイスチャンネルに参加して#{event.content}を入力してください。")
    #   else
    #     event.bot.voice_connect(channel)
    #   end
    # end

    def update_message(event, session)
      timer = session.timer
      timer.remaining = timer.end.to_i - Time.now.to_i
      countdown_msg = session.message
      if timer.remaining.negative?
        embed = Discordrb::Webhooks::Embed.new(
          title: countdown_msg.embeds[0].title,
          description: 'DONE!'
        )
        countdown_msg.edit('', embed)
        SessionController.end(event)
        return
      end
      embed = Discordrb::Webhooks::Embed.new(
        title: countdown_msg.embeds[0].title,
        description: "#{Timer.time_remaining(session)} left!"
      )
      countdown_msg.edit('', embed)
    end

    def start(event, session)
      session.timer.running = true
      loop do
        time_remaining = session.timer.remaining
        sleep 1
        session = SessionManager::ACTIVE_SESSIONS[SessionManager.session_id_from(event)]
        break unless session&.timer&.running && time_remaining == session.timer.remaining

        update_message(event, session)
      end
    end
  end
end
