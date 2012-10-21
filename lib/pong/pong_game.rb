require "entity"
require "renderable"
require 'gravity_sensitive'
require 'engine'

class PongGame < BasicGame

  # So before you start the game loop, you can initialize any data you wish inside the method init.
  # Why? Lets say you are initializing class variables or loading resources as you are playing the 
  # game, since these could be heavy actions on the computer, the game may slow down a bit so why 
  # not do that before the game cycle begins?
  def init(container)
    container.setTargetFrameRate(60)
    container.setAlwaysRender(true)

    @bg = Image.new('media/bg.png')
    
    @entities = []

    lander = Entity.new(self)
    lander.add_component(Renderable.new("media/lander.png"))
    lander.add_component(GravitySensitive.new)
    lander.add_component(Engine.new)
    
    @entities << lander
    #@pad = Pad.new(self)
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

    @entities.each {|e| e.update(container, delta) }
    # if @lander.intersects(@pad)
    #   Logger.global.log Level::SEVERE, "Intersection"
    # end
  end

  # After that the render method allows us to draw the world we designed accordingly 
  # to the variables calculated in the update method.
  def render(container, graphics)
    @bg.draw(0, 0)
    graphics.draw_string("RubyPong (ESC to exit)", 8, container.height - 30)

    @entities.each {|e| e.render(container, graphics)}
  end

end
