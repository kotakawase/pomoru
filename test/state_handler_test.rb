# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/pomoru/session/session'
require_relative '../lib/pomoru/state_handler'
require_relative '../lib/pomoru/state'
require_relative '../lib/pomoru/timer_setting'

class StateHandlerTest < Minitest::Test
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

  def test_state_handler_before_transition
    state = @session.state
    stats = @session.stats
    pomos_completed = stats.pomos_completed
    minutes_completed = stats.minutes_completed

    assert_equal('pomodoro', state)
    assert_equal(0, pomos_completed)
    assert_equal(0, minutes_completed)
  end

  def test_first_state_handler_after_transition
    StateHandler.transition(@session)
    state = @session.state
    stats = @session.stats
    pomos_completed = stats.pomos_completed
    minutes_completed = stats.minutes_completed

    assert_equal('short break', state)
    assert_equal(1, pomos_completed)
    assert_equal(25, minutes_completed)
  end

  def test_next_to_short_break_is_pomodoro
    @session.state = 'short break'
    stats = @session.stats
    stats.pomos_completed = 1
    stats.minutes_completed = 25

    StateHandler.transition(@session)

    state = @session.state
    stats = @session.stats
    pomos_completed = stats.pomos_completed
    minutes_completed = stats.minutes_completed

    assert_equal('pomodoro', state)
    assert_equal(1, pomos_completed)
    assert_equal(25, minutes_completed)
  end

  def test_repeat_pomodoro_4times_and_then_a_long_break
    stats = @session.stats
    stats.pomos_completed = 3
    stats.minutes_completed = 75

    StateHandler.transition(@session)

    state = @session.state
    stats = @session.stats
    pomos_completed = stats.pomos_completed
    minutes_completed = stats.minutes_completed

    assert_equal('long break', state)
    assert_equal(4, pomos_completed)
    assert_equal(100, minutes_completed)
  end

  def test_next_to_long_break_is_pomodoro
    @session.state = 'long break'
    stats = @session.stats
    stats.pomos_completed = 4
    stats.minutes_completed = 100

    StateHandler.transition(@session)

    state = @session.state
    stats = @session.stats
    pomos_completed = stats.pomos_completed
    minutes_completed = stats.minutes_completed

    assert_equal('pomodoro', state)
    assert_equal(4, pomos_completed)
    assert_equal(100, minutes_completed)
  end
end
