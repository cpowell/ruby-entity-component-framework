module Positionable
  attr_accessor  :position_x, :position_y

  def reposition_forward(amount)
    radians = @rotation * Math::PI / 180.0
    @position_x+= amount * Math.sin(radians)
    @position_y-= amount * Math.cos(radians)
  end
end
