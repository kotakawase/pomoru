# frozen_string_literal: true

require_relative './timer'
require_relative './stats'

class Session
  attr_reader :timer, :event, :stats
  attr_accessor :state, :settings, :message

  def initialize(state: nil, set: settings, ctx: event)
    @state = state
    @settings = set
    @event = ctx
    @timer = Timer.new(set)
    @stats = Stats.new
    @message = nil
  end
end
