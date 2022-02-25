# frozen_string_literal: true

require_relative '../../pomodoro/pomodoro_executer'
require 'discordrb'

module Bot::Commands
  module Control
    extend Discordrb::Commands::CommandContainer

    command :start do |event, pomodoro = 25, short_break = 5, long_break = 15, intervals = 4|
      channel = event.user.voice_channel
      if channel.nil?
        event.send_message('ボイスチャンネルに接続できません。接続するには[pmt!start]コマンドを入力するユーザーがボイスチャンネルに参加している必要があります。')
      else
        event.bot.voice_connect(channel)
        event.send_message("#{channel.name} に参加しました。")
        event.send_embed do |embed|
          embed.title = "Session settings"
          embed.description = "Pomodoro: #{pomodoro}min\nShort break: #{short_break}min\nLong break: #{long_break}min\nInterbals: #{intervals}"
        end
        pomodoro_executer = PomodoroExecuter.new(pomodoro, short_break, long_break, intervals)
        pomodoro_executer.run
        # event.voice.play_file("#{Dir.pwd}/sounds/sounds_pomo_start.mp3")
      end
    end

    # command :pause do |event|
    # end

    # command :resume do |event|
    # end

    # command :restart do |event|
    # end

    # command :skip do |event|
    # end

    command :end do |event|
      channel = event.user.voice_channel
      if channel
        event.bot.voice_destroy(event.server.id)
        event.send_message('Good Bye!')
        # next 'Good Bye!'
      else
        event.send_message('Can not disconnect')
      end
    end

    # command :edit do |event|
    # end
  end
end
