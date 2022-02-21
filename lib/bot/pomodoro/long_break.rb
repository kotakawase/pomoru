# frozen_string_literal: true

require_relative './break'

class LongBreak < Break
  def initialize
    super(type: :long)
  end
end
