# frozen_string_literal: true

require 'discordrb'
require 'minitest/autorun'
require_relative '../lib/pomoru/message_builder'
require_relative '../lib/pomoru/session/session'
require_relative '../lib/pomoru/state'
require_relative '../lib/pomoru/stats'
require_relative '../lib/pomoru/timer_setting'

class MessageBuilderTest < Minitest::Test
  def setup
    pomodoro = 25
    short_break = 5
    long_break = 15
    intervals = 4
    @session = Session.new(
      state: State::POMODORO,
      set: TimerSetting.new(
        pomodoro,
        short_break,
        long_break,
        intervals
      )
    )
  end

  def test_status_template
    title = 'Timer'
    status_str = <<~TEXT
      Current intervals: Pomodoro
      Status: Pausing
      Reminder alerts: Off
      Autoshush: Off
    TEXT
    colour = 3_066_993

    assert_equal(title, MessageBuilder.status_template(@session).title)
    assert_equal(status_str, MessageBuilder.status_template(@session).description)
    assert_equal(colour, MessageBuilder.status_template(@session).colour)
  end

  def test_settings_template
    title = 'Session settings'
    settings_str = <<~TEXT
      Pomodoro: 25 min
      Short break: 5 min
      Long break: 15 min
      Interbals: 4
    TEXT
    colour = 16_744_448

    assert_equal(title, MessageBuilder.settings_template(@session).title)
    assert_equal(settings_str, MessageBuilder.settings_template(@session).description)
    assert_equal(colour, MessageBuilder.settings_template(@session).colour)
  end

  def test_stats_template
    stats_str = '0 pomodoro (0分) 完了しました'
    assert_equal(stats_str, MessageBuilder.stats_template(@session.stats))
  end

  def test_no_arguments_passed_to_help_template
    summary = <<~TEXT
      ポモるで使えるコマンドヘルプ。

      必須パラメータは<>で囲まれ、オプションパラメーターは[]で囲まれます。
      たとえば「pmt!start」を実行してデフォルト値でポモドーロタイマーを開始したり、「pmt!start 30 10」を実行してポモドーロと休憩をカスタマイズしたりすることができます。

      もっと詳しいヘルプが知りたいときは、「pmt!help [command]」を実行することで確認することができるでしょう！
    TEXT
    colour = 3_447_003

    assert_equal('Help menu', MessageBuilder.help_template(nil).title)
    assert_equal(summary, MessageBuilder.help_template(nil).description)
    assert_equal(colour, MessageBuilder.help_template(nil).colour)
  end

  def test_command_is_passed_to_help_template
    start = <<~TEXT
      オプションのカスタム設定でポモドーロタイマーを開始します。
      各セッションは60分までパラメーターが有効です。
      （デフォルト値：25 5 15 4）

      pomodoro: ポモドーロの継続時間（分単位）
      short_break: 短い休憩の長さ（分単位）
      long_break: 長い休憩の長さ（分単位）
      intervals: 長い休憩をするまでにポモドーロする数
    TEXT

    assert_equal('start [pomodoro] [short_break] [long_break] [intervales]', MessageBuilder.help_template('start').title)
    assert_equal(start, MessageBuilder.help_template('start').description)
  end

  def test_countdown_template
    @session.state = State::COUNTDOWN
    @session.timer.remaining = 60
    title = 'Countdown'
    countdown_str = 'countdownは残り1分 00秒です！'
    colour = 1_752_220

    assert_equal(title, MessageBuilder.countdown_template(@session, title).title)
    assert_equal(countdown_str, MessageBuilder.countdown_template(@session, title).description)
    assert_equal(colour, MessageBuilder.countdown_template(@session, title).colour)
  end

  def test_reminder_template
    title = 'Reminder alerts'
    reminders_str = <<~TEXT
      Pomodoro: 5 min
      Short break: 1 min
      Long break: 5 min
    TEXT
    colour = 16_705_372

    assert_equal(title, MessageBuilder.reminder_template(@session).title)
    assert_equal(reminders_str, MessageBuilder.reminder_template(@session).description)
    assert_equal(colour, MessageBuilder.reminder_template(@session).colour)
  end
end
