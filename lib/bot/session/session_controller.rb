# frozen_string_literal: true

require_relative './session'
require_relative './session_manager'
require_relative './state_handler'

class SessionController
  class << self
    def start(event, session)
      channel = event.user.voice_channel
      if channel.nil?
        event.send_message("ボイスチャンネルに参加して#{session.ctx}を入力してください。")
      else
        event.bot.voice_connect(channel)
        event.send_message("#{channel.name} に参加しました。")
        event.send_embed do |embed|
          embed.title = 'Session settings'
          settings = session.settings
          embed.description = "Pomodoro: #{settings.pomodoro}min\nShort break: #{settings.short_break}min\nLong break: #{settings.long_break}min\nInterbals: #{settings.intervals}"
        end
        SessionManager.activate(event, session)
        # event.voice.play_file("#{Dir.pwd}/sounds/sounds_pomo_start.mp3")
        while true
          if !run(event, session)
            break
          end
        end
      end
    end

    def end(event)
      channel = event.user.voice_channel
      if channel
        event.bot.voice_destroy(event.server.id)
        event.send_message('Good Bye!')
      else
        event.send_message('Can not disconnect')
      end
    end

    def resume(event, session)
      while true
        if !run(event, session)
          break
        end
      end
    end

    private

    def run(event, session)
      session.timer.running = true
      timer_end = session.timer.end
      sleep session.timer.remaining
      session = SessionManager::ACTIVE_SESSIONS[SessionManager.session_id_from(event)]
      if !(session && session.timer.running && timer_end == session.timer.end)
        return false
      else
        # event.voice.play_file("#{Dir.pwd}/sounds/sounds_pomo_start.mp3")
        StateHandler.transition(event, session)
      end
      return true
    end
  end
end
