require 'entity'
require 'positionable'
require 'renderable'
require 'gravity_sensitive'

class Lander < Entity
  include Positionable
  include Renderable
  include GravitySensitive

  THRUST=0.01

  def initialize(game)
    super
    self.image = Image.new("media/lander.png")
    reset
  end

  def update(container, delta)
    input = container.get_input
    
    if input.is_key_down(Input::KEY_A)
      rotate(-0.2 * delta)
      self.rotation = image.rotation
    elsif input.is_key_down(Input::KEY_D)
      rotate(0.2 * delta)
      self.rotation = image.rotation
    elsif input.is_key_down(Input::KEY_S)
      self.vertical_speed -= THRUST * delta
    end

    # Gravity's effect on downward velocity...
    feel_gravity_effect(delta)

    # Fall according to velocity...
    fall(0.01 * delta * self.vertical_speed)
  end

  def reset
    self.vertical_speed = 0
    self.position_x = 200
    self.position_y = 200
    self.scale = 1.0
    self.rotation = 0
    image.setRotation(self.rotation)
    image.setCenterOfRotation(width/2.0*scale, height/2.0*scale)
  end

end
