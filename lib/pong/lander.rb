require 'forwardable'
require 'positionable'
require 'renderable'

class Lander
  include Positionable
  include Renderable

  extend Forwardable
  def_delegators :@image, :width, :height  # Its image knows the dimensions.

  def initialize(game)
    @game = game
    @image = Image.new("media/plane.png")
    reset
  end

  def update(container, delta)
    input = container.get_input
    
    if input.is_key_down(Input::KEY_A)
      @image.rotate(-0.2 * delta)
      @rotation = @image.rotation
    elsif input.is_key_down(Input::KEY_D)
      @image.rotate(0.2 * delta)
      @rotation = @image.rotation
    elsif input.is_key_down(Input::KEY_W)
      hypot = 0.2 * delta
      radians = @rotation * Math::PI / 180.0
      @position_x+= hypot * Math.sin(radians)
      @position_y-= hypot * Math.cos(radians)
    elsif input.is_key_down(Input::KEY_1)
      @scale -= (@scale <= 0.5) ? 0 : 0.01
      @image.setCenterOfRotation(width/2.0*@scale, height/2.0*@scale)
    elsif input.is_key_down(Input::KEY_2)
      @scale += (@scale >= 3.0) ? 0 : 0.01;
      @image.setCenterOfRotation(width/2.0*@scale, height/2.0*@scale)
    end
  end

  def reset
    @position_x = 200
    @position_y = 200
    @scale = 1.0
    @rotation = 0
    @image.setRotation(@rotation) # or @image.rotation=0
    @image.setCenterOfRotation(width/2.0*@scale, height/2.0*@scale)
  end

end
