# frozen_string_literal: true

require_relative './timer'
require_relative './stats'

class Session
  attr_reader :settings, :timer, :stats
  attr_accessor :state

  def initialize(state: nil, set: settings, ctx: content)
    @state = state
    @settings = set
    @ctx = ctx
    @timer = Timer.new(set)
    @stats = Stats.new
  end
end
