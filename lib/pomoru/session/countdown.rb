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

    def update_message(session)
      timer = session.timer
      timer.remaining = timer.end.to_i - Time.now.to_i
      countdown_msg = session.message
      embed_title = countdown_msg.embeds[0].title
      if timer.remaining.negative?
        embed = Discordrb::Webhooks::Embed.new(
          title: embed_title,
          description: 'DONE!'
        )
        countdown_msg.edit('', embed)
        SessionController.end(session)
        return
      end
      embed = Discordrb::Webhooks::Embed.new(
        title: embed_title,
        description: "#{timer.time_remaining(session)} left!"
      )
      countdown_msg.edit('', embed)
    end

    def start(session)
      session.timer.running = true
      loop do
        time_remaining = session.timer.remaining
        sleep 1
        session = SessionManager::ACTIVE_SESSIONS[SessionManager.session_id_from(session.event)]
        break unless session&.timer&.running && time_remaining == session.timer.remaining

        update_message(session)
      end
    end
  end
end
