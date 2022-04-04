# frozen_string_literal: true

require 'discordrb'
require_relative '../config/user_messages'
require_relative './session_activation'
require_relative './session_manipulation'
require_relative '../message_builder'
require_relative '../state'

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
      embed = MessageBuilder.countdown_embed('DONE', title, colour: 0xff0000)
      session.message.edit('', embed)
      SessionManipulation.end(session)
    end

    def running?(session)
      return unless session&.state == State::COUNTDOWN

      session.event.send_message(COUNTDOWN_RUNNING)
      true
    end

    private

    def latest_session?(session, timer_remaining)
      session = SessionActivation::ACTIVE_SESSIONS[SessionActivation.session_id_from(session.event)]
      session&.timer&.running && timer_remaining == session.timer.remaining
    end
  end
end
