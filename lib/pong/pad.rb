require 'entity'
require 'positionable'
require 'renderable'

class Pad < Entity
  include Positionable
  include Renderable

  def initialize(game)
    super
    self.image = Image.new("media/lander.png")
    reset
  end

  def update(container, delta)
  end

  def reset
    self.position_x = 50
    self.position_y = 150
    self.scale = 1.0
    self.rotation = 0
    image.setRotation(self.rotation)
    image.setCenterOfRotation(width/2.0*scale, height/2.0*scale)
  end

end
