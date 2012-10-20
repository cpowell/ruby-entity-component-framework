module Positionable
  attr_reader :velocity

  def reset_velocity
    @velocity = 0
  end

  def thrust_forward(amount)
    @velocity += amount
  end

  def reposition_forward(amount)
    direction_radians  = rotation * Math::PI / 180.0

    self.position_x += amount * Math.sin(direction_radians)
    self.position_y -= amount * Math.cos(direction_radians)
  end

  def downward(amount)
    dir = Math::PI
    self.position_y -= amount * Math.cos(dir)
  end
end
