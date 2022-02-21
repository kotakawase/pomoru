# frozen_string_literal: true

require_relative './break'

class ShortBreak < Break
  def initialize
    super(type: :short)
  end
end
