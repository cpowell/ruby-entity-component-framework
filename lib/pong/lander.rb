require 'entity'
require 'positionable'
require 'renderable'

class Lander < Entity
  include Positionable
  include Renderable

  def initialize(game)
    super
    self.image = Image.new("media/plane.png")
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
    elsif input.is_key_down(Input::KEY_W)
      thrust_forward(0.02)
    elsif input.is_key_down(Input::KEY_1)
      self.scale -= (scale <= 0.5) ? 0 : 0.01
      image.setCenterOfRotation(width/2.0*scale, height/2.0*scale)
    elsif input.is_key_down(Input::KEY_2)
      self.scale += (scale >= 3.0) ? 0 : 0.01;
      image.setCenterOfRotation(width/2.0*scale, height/2.0*scale)
    end

    reposition_forward(0.2 * delta * velocity)

  end

  def reset
    self.position_x = 200
    self.position_y = 200
    self.scale = 1.0
    self.rotation = 0
    reset_velocity
    image.setRotation(self.rotation)
    image.setCenterOfRotation(width/2.0*scale, height/2.0*scale)
  end

end
