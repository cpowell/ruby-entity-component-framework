require "lib/ball"
require "lib/paddle"

class PongGame < BasicGame
  attr_reader :ball, :paddle

  def init(container)
    @bg = Image.new('media/bg.png')
    @ball = Ball.new(self)
    @paddle = Paddle.new(self)
  end

  # delta contains the number of milliseconds since update 
  # was last called so we can use it to 'weight' the changes we make
  def update(container, delta)
    input = container.get_input
    container.exit if input.is_key_down(Input::KEY_ESCAPE)

    @ball.update(container, delta)
    @paddle.update(container, delta)
  end

  def render(container, graphics)
    @bg.draw(0, 0)
    @ball.render(container, graphics)
    @paddle.render(container, graphics)
    graphics.draw_string("RubyPong (ESC to exit)", 8, container.height - 30)
  end

  def reset
    @ball.reset
    @paddle.reset
  end

end
