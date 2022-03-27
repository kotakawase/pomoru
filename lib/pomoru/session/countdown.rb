# frozen_string_literal: true

require 'discordrb'
require_relative './session_controller'
require_relative '../message_builder'

class Countdown
  class << self
    def start(session)
      session.timer.running = true
      title = session.message.embeds[0].title
      timer_remaining = session.timer.remaining
      while Time.now < session.timer.end
        sleep 1
        return unless latest_session?(session, timer_remaining)

        embed = MessageBuilder.countdown_embed(session, title)
        session.message.edit('', embed)
      end
      embed = MessageBuilder.countdown_embed('DONE', title)
      session.message.edit('', embed)
      SessionController.end(session)
    end

    def latest_session?(session, timer_remaining)
      session = SessionManager::ACTIVE_SESSIONS[SessionManager.session_id_from(session.event)]
      session&.timer&.running && timer_remaining == session.timer.remaining
    end
  end
end
