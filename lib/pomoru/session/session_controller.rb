# frozen_string_literal: true

require_relative './session'
require_relative './session_manager'
require_relative './settings'
require_relative './state_handler'

class SessionController
  class << self
    def start(session)
      channel = session.event.user.voice_channel
      session.event.bot.voice_connect(channel)
      session.event.send_message("#{channel.name} に参加しました。")
      session.event.send_embed do |embed|
        embed.title = 'Session settings'
        settings = session.settings
        embed.description = "Pomodoro: #{settings.pomodoro}min\nShort break: #{settings.short_break}min\nLong break: #{settings.long_break}min\nInterbals: #{settings.intervals}"
      end
      SessionManager.activate(session)
      # event.voice.play_file("#{Dir.pwd}/sounds/sounds_pomo_start.mp3")
      loop do
        break unless run(session)
      end
    end

    def end(session)
      channel = session.event.user.voice_channel
      if channel
        SessionManager.deactivate(session)
        session.event.bot.voice_destroy(session.event.server.id)
        session.event.send_message('Good Bye!')
      else
        session.event.send_message('Can not disconnect')
      end
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
      session.event.send_message('Continuing pomodoro session with new settings!')
    end

    private

    def run(session)
      session.timer.running = true
      timer_end = session.timer.end
      sleep session.timer.remaining
      session = SessionManager::ACTIVE_SESSIONS[SessionManager.session_id_from(session.event)]
      return false unless session&.timer&.running && timer_end == session.timer.end

      # event.voice.play_file("#{Dir.pwd}/sounds/sounds_pomo_start.mp3")
      StateHandler.transition(session)
    end
  end
end
