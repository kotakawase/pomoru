require 'discordrb'
require 'dotenv/load'

bot = Discordrb::Commands::CommandBot.new(
  token: ENV['TOKEN'],
  client_id: ENV['CLIENT_ID'],
  prefix: ENV['PREFIX']
)

bot.command :start do |event|
	$voice_state = true
	channel = event.user.voice_channel
	if channel == nil
		event.send_message("ボイスチャンネルに接続できません。接続するには[pmt!start]コマンドを入力するユーザーがボイスチャンネルに参加している必要があります。")
	else
		bot.voice_connect(channel)
		event.send_message("#{channel.name} に参加しました。")
    event.voice.play_file("#{Dir.pwd}/sounds/sounds_pomo_start.mp3")
	end
end

bot.command :end do |event|
	if $voice_state then
		$voice_state = false
		bot.voice_destroy(event.server.id)
		next "Good Bye!"
	else
		event.send_message("Can not disconnect")
	end
end

bot.run
