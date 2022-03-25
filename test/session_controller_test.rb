# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/pomoru/session/reminder'
require_relative '../lib/pomoru/session/session_controller'
require_relative '../lib/pomoru/session/session'
require_relative '../lib/pomoru/settings'
require_relative '../lib/pomoru/state'

class SessionControllerTest < Minitest::Test
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

  # edit
  def test_pomodoro_timer_settings_before_editing
    assert_equal(25, @session.settings.pomodoro)
    assert_equal(5, @session.settings.short_break)
    assert_equal(15, @session.settings.long_break)
    assert_equal(4, @session.settings.intervals)
  end

  def test_pomodoro_timer_settings_after_editing
    SessionController.edit(@session, Settings.new(10, 5, 8, 3))
    assert_equal(10, @session.settings.pomodoro)
    assert_equal(5, @session.settings.short_break)
    assert_equal(8, @session.settings.long_break)
    assert_equal(3, @session.settings.intervals)
  end

  def test_set_the_pomodoro_timer_to_a_higher_value_when_the_reminder_is_on
    @session.reminder.running = true
    SessionController.edit(@session, Settings.new(6, 2, 6))
    assert_equal(5, @session.reminder.pomodoro)
    assert_equal(1, @session.reminder.short_break)
    assert_equal(5, @session.reminder.long_break)
  end

  def test_set_the_pomodoro_timer_to_the_same_value_when_reminders_are_on
    @session.reminder.running = true
    SessionController.edit(@session, Settings.new(5, 1, 5))
    assert_equal(1, @session.reminder.pomodoro)
    assert_equal('None', @session.reminder.short_break)
    assert_equal(1, @session.reminder.long_break)
  end

  def test_set_the_pomodoro_timer_to_a_lower_value_when_the_reminder_is_on
    @session.reminder.running = true
    SessionController.edit(@session, Settings.new(4, 0, 4))
    assert_equal('None', @session.reminder.pomodoro)
    assert_equal('None', @session.reminder.short_break)
    assert_equal('None', @session.reminder.long_break)
  end

  # when remind is executed after edit
  def test_if_pomodoro_and_long_break_are_lower_than_the_default_value_and_have_the_same_value
    SessionController.edit(@session, Settings.new(4, 1, 4))
    SessionController.remind(@session, Reminder.new(4, 1, 4))
    assert_equal('None', @session.reminder.pomodoro)
    assert_equal('None', @session.reminder.long_break)
  end

  def test_when_short_break_is_lower_than_the_default_value_and_has_the_same_value
    SessionController.edit(@session, Settings.new(5, 4, 5))
    SessionController.remind(@session, Reminder.new(5, 4, 5))
    assert_equal('None', @session.reminder.short_break)
  end

  def test_if_pomodoro_and_long_break_are_lower_than_the_default_value_and_not_the_same_value
    SessionController.edit(@session, Settings.new(4, 1, 4))
    SessionController.remind(@session, Reminder.new(3, 1, 2))
    assert_equal(3, @session.reminder.pomodoro)
    assert_equal(2, @session.reminder.long_break)
  end

  def test_when_short_break_is_lower_than_the_default_value_and_not_the_same_value
    SessionController.edit(@session, Settings.new(5, 4, 5))
    SessionController.remind(@session, Reminder.new(5, 3, 5))
    assert_equal(3, @session.reminder.short_break)
  end

  # remind
  def test_reminder_settings_before_editing
    assert_equal(5, @session.reminder.pomodoro)
    assert_equal(1, @session.reminder.short_break)
    assert_equal(5, @session.reminder.long_break)
  end

  def test_all_reminder_settings_are_more_than_pomodoro_timer
    SessionController.remind(@session, Reminder.new(26, 6, 16))
    assert_equal(1, @session.reminder.pomodoro)
    assert_equal(1, @session.reminder.short_break)
    assert_equal(1, @session.reminder.long_break)
  end

  def test_all_reminder_settings_are_same_as_the_pomodoro_timer
    SessionController.remind(@session, Reminder.new(25, 5, 15))
    assert_equal(1, @session.reminder.pomodoro)
    assert_equal(1, @session.reminder.short_break)
    assert_equal(1, @session.reminder.long_break)
  end

  def test_reminder_settings_after_editing
    SessionController.remind(@session, Reminder.new(24, 4, 14))
    assert_equal(24, @session.reminder.pomodoro)
    assert_equal(4, @session.reminder.short_break)
    assert_equal(14, @session.reminder.long_break)
  end

  def test_all_reminder_settings_are_0
    SessionController.remind(@session, Reminder.new(0, 0, 0))
    assert_equal('None', @session.reminder.pomodoro)
    assert_equal('None', @session.reminder.short_break)
    assert_equal('None', @session.reminder.long_break)
  end
end
