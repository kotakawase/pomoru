# frozen_string_literal: true

require_relative './session'
require_relative './session_messenger'
require_relative './session_manager'
require_relative './settings'
require_relative './state_handler'

class SessionController
  class << self
    def start(session)
      channel = session.event.user.voice_channel
      session.event.bot.voice_connect(channel)
      session.event.send_message("#{channel.name} に参加しました。")
      SessionManager.activate(session)
      SessionMessenger.send_start_msg(session)
      # event.voice.play_file()
      loop do
        break unless run(session)
      end
    end

    def end(session)
      SessionManager.deactivate(session)
      session.event.bot.voice_destroy(session.event.server.id)
    end

    def resume(session)
      loop do
        break unless run(session)
      end
    end

    def edit(session, new_settings)
      short_break = new_settings.short_break || session.settings.short_break
      long_break = new_settings.long_break || session.settings.long_break
      intervals = new_settings.intervals || session.settings.intervals
      session.settings = Settings.new(new_settings.pomodoro, short_break, long_break, intervals)
      SessionMessenger.send_edit_msg(session)
    end

    private

    def run(session)
      session.timer.running = true
      timer_end = session.timer.end
      sleep session.timer.remaining
      session = SessionManager::ACTIVE_SESSIONS[SessionManager.session_id_from(session.event)]
      return false unless session&.timer&.running && timer_end == session.timer.end

      # event.voice.play_file()
      StateHandler.transition(session)
    end
  end
end
