# frozen_string_literal: true

require_relative './pomodoro'
require_relative './short_break'
require_relative './long_break'

class PomodoroExecuter
  def initialize(*duration)
    @pomodoro_count = 0
    @short_break_count = 0
    @long_break_count = 0
    @four_pomodoro_cycle_count = 0
    @pomodoro = duration[0].to_i
    @short_break = duration[1].to_i
    @long_break = duration[2].to_i
    @intervals = duration[3].to_i
  end

  def run
    loop do
      pomodoro_cycle_with_logs
      pomodoro_with_logs
      long_break_with_logs
      @four_pomodoro_cycle_count += 1
      puts "4ポモドーロセット#{(((Pomodoro::MINUTES + Break::SHORT_MINUTES) * 3) + (Pomodoro::MINUTES + Break::LONG_MINUTES)) * @four_pomodoro_cycle_count}分経過"
    end
  end

  private

  def pomodoro_cycle_with_logs
    (@intervals - 1).times do
      pomodoro_with_logs
      short_break_with_logs
    end
  end

  def pomodoro_with_logs
    @pomodoro_count += 1
    puts "ポモドーロ#{@pomodoro_count}回目スタート"
    Pomodoro.new(@pomodoro).run
  end

  def short_break_with_logs
    @short_break_count += 1
    puts "ショートブレイク#{@short_break_count}回目スタート"
    ShortBreak.new(@short_break).run
  end

  def long_break_with_logs
    @long_break_count += 1
    puts "ロングブレイク#{@long_break_count}回目スタート"
    LongBreak.new(@long_break).run
  end
end