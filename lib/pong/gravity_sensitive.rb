module GravitySensitive
  ACCELERATION = 0.005 # m/s^2

  attr_accessor :vertical_speed

  def feel_gravity_effect(delta)
    self.vertical_speed += ACCELERATION * delta
  end

  def fall(amount)
    dir = Math::PI
    self.position_y -= amount * Math.cos(dir)
  end

end
