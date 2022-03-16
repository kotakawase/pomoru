# frozen_string_literal: true

require_relative './autoshush'
require_relative './reminder'
require_relative '../stats'
require_relative '../timer'

class Session
  attr_reader :timer, :event, :stats, :autoshush
  attr_accessor :state, :settings, :message, :reminder

  def initialize(state: nil, set: settings, ctx: event)
    @state = state
    @settings = set
    @event = ctx
    @timer = Timer.new(set)
    @stats = Stats.new
    @reminder = Reminder.new(Reminder::POMO_REMIND, Reminder::SHORT_REMIND, Reminder::LONG_REMIND)
    @message = nil
    @autoshush = AutoShush.new
  end
end
