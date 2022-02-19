# frozen_string_literal: true

require 'discordrb'

module Bot::Commands
  module Control
    extend Discordrb::Commands::CommandContainer

    command :start do |event|
      channel = event.user.voice_channel
      if channel.nil?
        event.send_message('ボイスチャンネルに接続できません。接続するには[pmt!start]コマンドを入力するユーザーがボイスチャンネルに参加している必要があります。')
      else
        event.bot.voice_connect(channel)
        event.send_message("#{channel.name} に参加しました。")
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
        next 'Good Bye!'
      else
        event.send_message('Can not disconnect')
      end
    end

    # command :edit do |event|
    # end
  end
end
