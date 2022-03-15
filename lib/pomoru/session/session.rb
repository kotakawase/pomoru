# frozen_string_literal: true

require_relative './timer'
require_relative './stats'
require_relative './reminder'

class Session
  attr_reader :timer, :event, :stats
  attr_accessor :state, :settings, :message, :reminder

  def initialize(state: nil, set: settings, ctx: event)
    @state = state
    @settings = set
    @event = ctx
    @timer = Timer.new(set)
    @stats = Stats.new
    @reminder = Reminder.new(Reminder::POMO_REMIND, Reminder::SHORT_REMIND, Reminder::LONG_REMIND)
    @message = nil
  end
end
