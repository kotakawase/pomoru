# frozen_string_literal: true

require_relative './timer'
require_relative './stats'

class Session
  attr_reader :timer, :ctx, :stats
  attr_accessor :state, :settings, :message

  def initialize(state: nil, set: settings, ctx: content)
    @state = state
    @settings = set
    @ctx = ctx
    @timer = Timer.new(set)
    @stats = Stats.new
    @message = nil
  end
end
