# frozen_string_literal: true

require 'discordrb'
require 'minitest/autorun'
require_relative '../lib/pomoru/message_builder'
require_relative '../lib/pomoru/session/session'
require_relative '../lib/pomoru/settings'
require_relative '../lib/pomoru/state'
require_relative '../lib/pomoru/stats'

class MessageBuilderTest < Minitest::Test
  def setup
    pomodoro = 25
    short_break = 5
    long_break = 15
    intervals = 4
    @session = Session.new(
      state: State::POMODORO,
      set: Settings.new(
        pomodoro,
        short_break,
        long_break,
        intervals
      )
    )
  end

  def test_status_embed
    title = 'Timer'
    status_str = "Current intervals: Pomodoro\n \
        Status: Pausing\n \
        Reminder alerts: Off\n \
        Autoshush: Off"

    assert_equal(title, MessageBuilder.status_embed(@session).title)
    assert_equal(status_str, MessageBuilder.status_embed(@session).description)
  end

  def test_settings_embed
    title = 'Session settings'
    settings_str = "Pomodoro: 25 min\n \
        Short break: 5 min\n \
        Long break: 15 min\n \
        Interbals: 4"

    assert_equal(title, MessageBuilder.settings_embed(@session).title)
    assert_equal(settings_str, MessageBuilder.settings_embed(@session).description)
  end

  def test_stats_embed
    stats_msg = 'You completed 0 pomodoro (0minutes)'
    assert_equal(stats_msg, MessageBuilder.stats_msg(@session.stats))
  end

  def test_no_arguments_passed_to_help_embed
    summary = <<~TEXT
      pomoru is a Discord bot that allows you to use the Pomodoro technique on Discord.
      Set periods of focus to get work done and chat during the breaks.

      Required parameters are enclosed in <> and optional parameters are enclosed in [].
      For example, you can do "pmt!start" to start a pomodoro session with the default values or "pmt!start 30 10" to customize the pomodoro and short break durations!
    TEXT

    assert_equal('Help menu', MessageBuilder.help_embed(nil).title)
    assert_equal(summary, MessageBuilder.help_embed(nil).description)
  end

  def test_command_is_passed_to_help_embed
    start = <<~TEXT
      Start pomodoro session with optional custom settings.

      pomodoro: duration of each pomodoro interval in minutes (default: 25 min)
      short_break: duration of short breaks in minutes (default: 5 min)
      long_break: duration of long breaks in minutes (default: 15 min)
      intervals: number of pomodoro intervals between each long break (default: 4)
    TEXT

    assert_equal('start [pomodoro] [short_break] [long_break] [intervales]', MessageBuilder.help_embed('start').title)
    assert_equal(start, MessageBuilder.help_embed('start').description)
  end

  def test_countdown_embed
    @session.state = State::COUNTDOWN
    @session.timer.remaining = 60
    title = 'Countdown'
    countdown_str = '1minutes 00seconds remining on countdown! left!'

    assert_equal(title, MessageBuilder.countdown_embed(@session, title).title)
    assert_equal(countdown_str, MessageBuilder.countdown_embed(@session, title).description)
  end

  def test_reminders_embed
    title = 'Reminder alerts'
    reminders_str = "Pomodoro: 5 min\n \
        Short break: 1 min\n \
        Long break: 5 min"

    assert_equal(title, MessageBuilder.reminders_embed(@session).title)
    assert_equal(reminders_str, MessageBuilder.reminders_embed(@session).description)
  end
end
