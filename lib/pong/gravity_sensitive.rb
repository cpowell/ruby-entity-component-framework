require 'forwardable'
require 'component'

class GravitySensitive < Component
  ACCELERATION = 0.005 # m/s^2

  attr_accessor :vertical_speed

  def initialize
    super()
    @vertical_speed = 0
  end

  def update(container, delta)
    # feel gravity's effect
    @vertical_speed += ACCELERATION * delta

    # fall
    dir = Math::PI
    amount = 0.01 * delta * @vertical_speed
    @owner.components.each do |c|
      if c.respond_to?(:render)
        c.position_y -= amount * Math.cos(dir)
      end
    end
  end
end
