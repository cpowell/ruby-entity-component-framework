require 'SecureRandom'

require 'entity_manager'
require 'meta_entity'

# Necesssary components
require 'spatial_state'
require 'gravity_sensitive'
require 'player_input'
require 'fuel'
require 'polygon_collidable'

# Necessary systems
require 'rendering_system'
require 'physics'
require 'input_system'
require 'spatial_system'
require 'collision_system'

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
    #MetaEntity.default_entity_manager=@entity_manager

    # Using direct entities:
    p1_lander = @entity_manager.create_named_entity('p1_lander')
    @entity_manager.add_component p1_lander, SpatialState.new(50, 50, 0, 0)
    @entity_manager.add_component p1_lander, Engine.new(0.01)
    @entity_manager.add_component p1_lander, Fuel.new(250)
    @entity_manager.add_component p1_lander, Renderable.new(RELATIVE_ROOT + "res/lander.png", 1.0, 0)
    @entity_manager.add_component p1_lander, GravitySensitive.new
    @entity_manager.add_component p1_lander, PolygonCollidable.new
    @entity_manager.add_component p1_lander, PlayerInput.new([Input::KEY_A,Input::KEY_D,Input::KEY_S])

    # Using "meta" entities:
    # p1_lander = MetaEntity.new('p1_lander')
    # p1_lander.add_component SpatialState.new(50, 50, 0, 0)
    # #p1_lander.add_component Engine.new(0.01)
    # p1_lander.add_component Renderable.new(RELATIVE_ROOT + "res/lander.png", 1.0, 0)
    # p1_lander.add_component GravitySensitive.new
    # p1_lander.add_component PlayerInput.new([Input::KEY_A,Input::KEY_D,Input::KEY_S])

    p2_lander = @entity_manager.create_named_entity('p2_lander')
    @entity_manager.add_component p2_lander, SpatialState.new(250, 50, 0, 0)
    @entity_manager.add_component p2_lander, Engine.new(0.02)
    @entity_manager.add_component p2_lander, Fuel.new(250)
    @entity_manager.add_component p2_lander, Renderable.new(RELATIVE_ROOT + "res/lander.png", 1.0, 0)
    @entity_manager.add_component p2_lander, GravitySensitive.new
    @entity_manager.add_component p2_lander, PolygonCollidable.new
    @entity_manager.add_component p2_lander, PlayerInput.new([Input::KEY_J,Input::KEY_K,Input::KEY_L])

    platform = @entity_manager.create_named_entity('platform')
    @entity_manager.add_component platform, SpatialState.new(350, container.height - 25, 0, 0)
    @entity_manager.add_component platform, Renderable.new(RELATIVE_ROOT + "res/shelf.png", 1.0, 0)
    @entity_manager.add_component platform, PolygonCollidable.new

    @entity_manager.dump_to_screen

    # Initialize any runnable systems
    @physics   = Physics.new(self)
    @input     = InputSystem.new(self)
    @renderer  = RenderingSystem.new(self)
    @engine    = EngineSystem.new(self)
    @collision = CollisionSystem.new(self)
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
    @collision.process_one_game_tick(container, delta, @entity_manager)
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
  end

  # # id is the name of the method called, the * syntax collects
  # # all the arguments in an array named 'arguments'
  # def broadcast_systems_message(method, *arguments )
  #   #puts "Method #{method} was called, but not found. It has these arguments: #{arguments.join(", ")}"
  #   @systems.each do |sys|
  #     if sys.respond_to?(method)
  #       sys.send method, *arguments
  #     end
  #   end
  # end  

  # # Stops at the first system who replies to the interrogatory
  # def broadcast_systems_interrogatory(method, *arguments)
  #   @systems.each do |sys|
  #     if sys.respond_to?(method)
  #       reply=sys.send method, *arguments
  #       return reply
  #     end
  #   end
  # end
end

