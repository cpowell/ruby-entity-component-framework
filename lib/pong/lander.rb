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
      self.rotation = self.image.rotation
    elsif input.is_key_down(Input::KEY_D)
      rotate(0.2 * delta)
      self.rotation = self.image.rotation
    elsif input.is_key_down(Input::KEY_W)
      reposition_forward(0.2 * delta)
    elsif input.is_key_down(Input::KEY_1)
      self.scale -= (self.scale <= 0.5) ? 0 : 0.01
      image.setCenterOfRotation(width/2.0*self.scale, height/2.0*self.scale)
    elsif input.is_key_down(Input::KEY_2)
      self.scale += (self.scale >= 3.0) ? 0 : 0.01;
      image.setCenterOfRotation(width/2.0*self.scale, height/2.0*self.scale)
    end
  end

  def reset
    self.position_x = 200
    self.position_y = 200
    self.scale = 1.0
    self.rotation = 0
    image.setRotation(self.rotation)
    image.setCenterOfRotation(width/2.0*self.scale, height/2.0*self.scale)
  end

end
