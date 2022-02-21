require_relative './break'

class ShortBreak < Break
  def initialize
    super(type: :short)
  end
end
