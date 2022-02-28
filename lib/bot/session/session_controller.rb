# frozen_string_literal: true

require_relative './session'
require_relative './session_maneger'
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
        SessionManeger.activate(event, session)
        # event.voice.play_file("#{Dir.pwd}/sounds/sounds_pomo_start.mp3")
        run(event, session)
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

    private

    def run(event, session)
      loop do
        session.timer.running = true
        # timer_end = session.timer.end
        sleep session.timer.remaining
        # event.voice.play_file("#{Dir.pwd}/sounds/sounds_pomo_start.mp3")
        StateHandler.transition(event, session)
      end
    end
  end
end
