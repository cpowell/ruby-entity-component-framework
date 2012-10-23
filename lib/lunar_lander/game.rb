# Necesssary components
require 'entity_manager'
require 'screen_location'
require 'gravity_sensitive'
require 'player_input'

# Necessary systems
require 'renderer'
require 'physics'
require 'input_system'

class Game < BasicGame

  # Before you start the game loop, you can initialize any data you wish inside the method init.
  #
  # * *Args*    :
  #   - +container+ -> game container that handles the game loop, fps recording and managing the input system
  #
  def init(container)
    container.setTargetFrameRate(60)
    container.setAlwaysRender(true)

    @bg = Image.new('media/bg.png')
    @em = EntityManager.new(self)

    lander = @em.create_named_entity('lander')
    @em.add_component lander, ScreenLocation.new(50, 50)
    @em.add_component lander, Renderable.new("media/lander.png", 1.0, 0)
    @em.add_component lander, GravitySensitive.new
    @em.add_component lander, PlayerInput.new([Input::KEY_A,Input::KEY_D,Input::KEY_S])
    
    @em.dump_to_screen

    # Initialize any runnable systems
    @renderer = Renderer.new
    @physics  = Physics.new
    @input    = InputSystem.new
  end

  # The update method is called during the game to update the logic in our world, 
  # within this method we can obtain the user input, calculate the world response 
  # to the input, do extra calculation like the AI of the enemies, etc. Your game logic goes here.
  #
  # * *Args*    :
  #   - +container+ -> game container that handles the game loop, fps recording and managing the input system
  #   - +delta+ -> the number of ms since update was last called. We can use it to 'weight' the changes we make.
  #
  def update(container, delta)
    input = container.get_input
    container.exit if input.is_key_down(Input::KEY_ESCAPE)

    @physics.process_one_game_tick(container, delta, @em)
    @input.process_one_game_tick(container, delta, @em)
  end

  # After that the render method allows us to draw the world we designed accordingly 
  # to the variables calculated in the update method.
  #
  # * *Args*    :
  #   - +container+ -> game container that handles the game loop, fps recording and managing the input system
  #   - +graphics+ -> graphics context that can be used to render. However, normal rendering routines can also be used.
  #
  def render(container, graphics)
    @bg.draw(0, 0)
    graphics.draw_string("Lunar Lander (ESC to exit)", 8, container.height - 30)

    @renderer.process_one_game_tick(@em)
  end
end


#require 'engine'
#require 'maneuvering_thrusters'

    # lander = Entity.new(self)
    # lander.add_component(Renderer.new("media/lander.png", 50, 50, 1.0, 0))
    # lander.add_component(Physics.new)
    # lander.add_component(ManeuveringThrusters.new)
    # lander.add_component(Engine.new(200))
    # @entities << lander
    # pad = Entity.new(self)
    # pad.add_component(Renderer.new("media/shelf.png", 250, 150, 1.0, 0))
    # @entities << pad


    #@entities.each {|e| e.update(container, delta) }
    # if @lander.intersects(@pad)
    #   Logger.global.log Level::SEVERE, "Intersection"
    # end
