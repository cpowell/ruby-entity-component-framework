module Positionable
  def reposition_forward(amount)
    radians = rotation * Math::PI / 180.0

    self.position_x += amount * Math.sin(radians)
    self.position_y -= amount * Math.cos(radians)
  end
end
