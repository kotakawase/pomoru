# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/pomoru/session/session'
require_relative '../lib/pomoru/settings'
require_relative '../lib/pomoru/state'

class SettingsTest < Minitest::Test
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

  def test_pomodoro_timer_setting_is_valid
    settings = @session.settings
    pomodoro = settings.pomodoro
    short_break = settings.short_break
    long_break = settings.long_break
    intervals = settings.intervals
    # 設定は有効の場合はfalseが返る
    refute(Settings.invalid?(pomodoro, short_break, long_break, intervals))
  end

  def test_valid_when_pomodoro_setting_is_60
    refute(Settings.invalid?(60))
  end

  def test_valid_when_short_break_setting_is_60
    settings = @session.settings
    pomodoro = settings.pomodoro
    refute(Settings.invalid?(pomodoro, 60))
  end

  def test_valid_when_longbreak_break_setting_is_60
    settings = @session.settings
    pomodoro = settings.pomodoro
    short_break = settings.short_break
    refute(Settings.invalid?(pomodoro, short_break, 60))
  end

  def test_valid_when_intervals_setting_is_60
    settings = @session.settings
    pomodoro = settings.pomodoro
    short_break = settings.short_break
    long_break = settings.long_break
    refute(Settings.invalid?(pomodoro, short_break, long_break, 60))
  end

  def test_invalid_when_pomodoro_setting_is_60_or_more
    assert(Settings.invalid?(61))
  end

  def test_invalid_when_short_break_setting_is_60_or_more
    settings = @session.settings
    pomodoro = settings.pomodoro
    assert(Settings.invalid?(pomodoro, 61))
  end

  def test_invalid_when_longbreak_break_setting_is_60_or_more
    settings = @session.settings
    pomodoro = settings.pomodoro
    short_break = settings.short_break
    assert(Settings.invalid?(pomodoro, short_break, 61))
  end

  def test_invalid_when_intervals_setting_is_60_or_more
    settings = @session.settings
    pomodoro = settings.pomodoro
    short_break = settings.short_break
    long_break = settings.long_break
    assert(Settings.invalid?(pomodoro, short_break, long_break, 61))
  end

  def test_invalid_if_pomodoro_setting_is_0
    assert(Settings.invalid?(0))
  end

  def test_invalid_if_short_break_setting_is_0
    settings = @session.settings
    pomodoro = settings.pomodoro
    assert(Settings.invalid?(pomodoro, 0))
  end

  def test_invalid_if_longbreak_break_setting_is_0
    settings = @session.settings
    pomodoro = settings.pomodoro
    short_break = settings.short_break
    assert(Settings.invalid?(pomodoro, short_break, 0))
  end

  def test_invalid_if_intervals_setting_is_0
    settings = @session.settings
    pomodoro = settings.pomodoro
    short_break = settings.short_break
    long_break = settings.long_break
    assert(Settings.invalid?(pomodoro, short_break, long_break, 0))
  end
end
