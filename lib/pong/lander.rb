require "forwardable"

class Lander
  extend Forwardable

  # Its image knows the dimensions.
  def_delegators :@image, :width, :height

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
      @x+= hypot * Math.sin(radians)
      @y-= hypot * Math.cos(radians)
    elsif input.is_key_down(Input::KEY_1)
      @scale -= (@scale <= 0.5) ? 0 : 0.01
      @image.setCenterOfRotation(width/2.0*@scale, height/2.0*@scale)
    elsif input.is_key_down(Input::KEY_2)
      @scale += (@scale >= 3.0) ? 0 : 0.01;
      @image.setCenterOfRotation(width/2.0*@scale, height/2.0*@scale)
    end
  end

  def render(container, graphics)
    @image.draw(@x, @y, @scale)
  end

  def reset
    @x = 200
    @y = 200
    @scale = 1.0
    @rotation = 0
    @image.setRotation(@rotation) # or @image.rotation=0
    @image.setCenterOfRotation(width/2.0*@scale, height/2.0*@scale)
  end

end

  # attr_accessor :angle
  # def_delegators :game, :paddle

  # attr_accessor :x, :y, :game

      #Logger.global.log Level::INFO, "Rotation change = #{@rotation_change}"
