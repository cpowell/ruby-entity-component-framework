require "lib/ball"
require "lib/paddle"

class PongGame < BasicGame
  attr_reader :ball, :paddle

  # So before you start the game loop, you can initialize any data you wish inside the method init.
  # Why? Lets say you are initializing class variables or loading resources as you are playing the 
  # game, since these could be heavy actions on the computer, the game may slow down a bit so why 
  # not do that before the game cycle begins?
  def init(container)
    @bg = Image.new('media/bg.png')
    @ball = Ball.new(self)
    @paddle = Paddle.new(self)

    @plane = Image.new('media/plane.png')
    @x=250
    @y=250
    @scale = 1.0
  end

  # The update method is called during the game to update the logic in our world, 
  # within this method we can obtain the user input, calculate the world response 
  # to the input, do extra calculation like the AI of the enemies, etc. Your game logic goes here.
  #
  # * *Args*    :
  #   - +container+ -> the actual implementation of the game loop
  #   - +delta+ -> the number of ms since update was last called. We can use it to 'weight' the changes we make.
  #
  def update(container, delta)
    input = container.get_input
    container.exit if input.is_key_down(Input::KEY_ESCAPE)

    @ball.update(container, delta)
    @paddle.update(container, delta)

    if input.is_key_down(Input::KEY_A)
      @plane.rotate(-0.2 * delta)
    elsif input.is_key_down(Input::KEY_D)
      @plane.rotate(0.2 * delta)
    elsif input.is_key_down(Input::KEY_W)
      hypot = 0.2 * delta;
      rotation = @plane.getRotation
 
      @x+= hypot * Math.sin(rotation * Math::PI / 180.0)
      @y-= hypot * Math.cos(rotation * Math::PI / 180.0)
    elsif input.is_key_down(Input::KEY_1)
      @scale -= (@scale <= 0.5) ? 0 : 0.01
      @plane.setCenterOfRotation(@plane.getWidth/2.0*@scale, @plane.getHeight/2.0*@scale)
    elsif input.is_key_down(Input::KEY_2)
      @scale += (@scale >= 3.0) ? 0 : 0.01;
      @plane.setCenterOfRotation(@plane.getWidth/2.0*@scale, @plane.getHeight/2)
    end
  end

  # After that the render method allows us to draw the world we designed accordingly 
  # to the variables calculated in the update method.
  def render(container, graphics)
    @bg.draw(0, 0)

    @plane.draw(@x, @y, @scale)


    @ball.render(container, graphics)
    @paddle.render(container, graphics)
    graphics.draw_string("RubyPong (ESC to exit)", 8, container.height - 30)
  end

  def reset
    @ball.reset
    @paddle.reset
  end

end
