require 'component'

class Fuel < Component
  attr_accessor :remaining

  def initialize(remaining)
    super()
    @remaining=remaining
  end

  def burn(qty)
    @remaining -= qty
    @remaining = 0 if @remaining < 0
  end
end
