require "lib/pong/lander"

class PongGame < BasicGame

  # So before you start the game loop, you can initialize any data you wish inside the method init.
  # Why? Lets say you are initializing class variables or loading resources as you are playing the 
  # game, since these could be heavy actions on the computer, the game may slow down a bit so why 
  # not do that before the game cycle begins?
  def init(container)
    @bg = Image.new('media/bg.png')
    @lander = Lander.new(self)
    #container.setSmoothDeltas(true)
    container.setTargetFrameRate(60)
    container.setAlwaysRender(true)
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
    reset if input.is_key_down(Input::KEY_R)
    container.exit if input.is_key_down(Input::KEY_ESCAPE)

    @lander.update(container, delta)
  end

  # After that the render method allows us to draw the world we designed accordingly 
  # to the variables calculated in the update method.
  def render(container, graphics)
    @bg.draw(0, 0)
    #graphics.draw_string("RubyPong (ESC to exit)", 8, container.height - 30)

    @lander.render(container, graphics)
  end

  def reset
    @lander.reset
  end

end
