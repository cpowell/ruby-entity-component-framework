require 'SecureRandom'

require 'entity_manager'
require 'meta_entity'

# Necesssary components
require 'spatial_state'
require 'gravity_sensitive'
require 'motion'
require 'player_input'
require 'fuel'
require 'polygon_collidable'
require 'landable'
require 'pad'

# Necessary systems
require 'rendering_system'
require 'physics'
require 'input_system'
require 'spatial_system'
require 'collision_system'
require 'landing_system'

class Game < BasicGame
  attr_reader :entity_manager

  # Before you start the game loop, you can initialize any data you wish inside the method init.
  #
  # * *Args*    :
  #   - +container+ -> game container that handles the game loop, fps recording and managing the input system
  #
  def init(container)
    container.setTargetFrameRate(60)
    container.setAlwaysRender(true)

    @bg = Image.new(RELATIVE_ROOT + 'res/bg.png')
    @entity_manager = EntityManager.new(self)
    @game_over=false
    @landed=false

    p1_lander = @entity_manager.create_named_entity('p1_lander')
    @entity_manager.add_entity_component p1_lander, SpatialState.new(50, 250, 0, 0)
    @entity_manager.add_entity_component p1_lander, Engine.new(0.01)
    @entity_manager.add_entity_component p1_lander, Fuel.new(250)
    @entity_manager.add_entity_component p1_lander, Renderable.new(RELATIVE_ROOT + "res/lander.png", 1.0, 0)
    @entity_manager.add_entity_component p1_lander, GravitySensitive.new
    @entity_manager.add_entity_component p1_lander, Motion.new
    @entity_manager.add_entity_component p1_lander, PolygonCollidable.new
    @entity_manager.add_entity_component p1_lander, Landable.new
    @entity_manager.add_entity_component p1_lander, PlayerInput.new([Input::KEY_A,Input::KEY_D,Input::KEY_S])

    platform = @entity_manager.create_named_entity('platform')
    @entity_manager.add_entity_component platform, SpatialState.new(350, container.height - 125, 0, 0)
    @entity_manager.add_entity_component platform, Renderable.new(RELATIVE_ROOT + "res/shelf.png", 1.0, 0)
    @entity_manager.add_entity_component platform, Pad.new

    ground = @entity_manager.create_named_entity('ground')
    @entity_manager.add_entity_component ground, SpatialState.new(0, container.height - 118, 0, 0)
    @entity_manager.add_entity_component ground, Renderable.new(RELATIVE_ROOT + "res/ground.png", 1.0, 0)
    @entity_manager.add_entity_component ground, PolygonCollidable.new

    @entity_manager.dump_to_screen

    # Initialize any runnable systems
    @physics   = Physics.new(self)
    @input     = InputSystem.new(self)
    @renderer  = RenderingSystem.new(self)
    @engine    = EngineSystem.new(self)
    @collision = CollisionSystem.new(self)
    @landing   = LandingSystem.new(self)
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

    # Nice because I can dictate the order things are processed
    @engine.process_one_game_tick(container, delta, @entity_manager)
    @physics.process_one_game_tick(container, delta, @entity_manager)
    @input.process_one_game_tick(container, delta, @entity_manager)
    @landed = @landing.process_one_game_tick(container, delta, @entity_manager)
    @game_over = @collision.process_one_game_tick(container, delta, @entity_manager)
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

    @renderer.process_one_game_tick(@entity_manager, container, graphics)

    if @landed
      container.graphics.draw_string("Hooray you made it!", 50, 50)
      container.pause
    elsif @game_over
      container.graphics.draw_string("BANG you're dead", 50, 50)
      container.pause
    end

  end

end

