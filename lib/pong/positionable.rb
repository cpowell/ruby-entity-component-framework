module Positionable
  attr_reader :velocity

  def reset_velocity
    @velocity = 0
  end
  
  def thrust_forward(amount)
    @velocity += amount
  end

  def reposition_forward(amount)
    radians = rotation * Math::PI / 180.0

    self.position_x += amount * Math.sin(radians)
    self.position_y -= amount * Math.cos(radians)
  end
end
