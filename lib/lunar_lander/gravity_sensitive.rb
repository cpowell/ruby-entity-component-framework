require 'forwardable'
require 'component'

class GravitySensitive < Component
  ACCELERATION = 0.005 # m/s^2

  def initialize
    super()
    @vertical_speed = 0
  end

  def update(container, delta)
    # feel gravity's effect
    @vertical_speed += ACCELERATION * delta

    # fall
    direction = Math.cos(Math::PI)
    amount    = -0.01 * delta * @vertical_speed
    @owner.reposition_y(amount * direction)
  end

  def reduce_vertical_speed(amount)
    @vertical_speed -= amount
  end
end
