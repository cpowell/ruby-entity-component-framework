require 'SecureRandom'

require 'entity_manager'
require 'meta_entity'

# Necesssary components
require 'spatial_state'
require 'gravity_sensitive'
require 'player_input'

# Necessary systems
require 'renderer'
require 'physics'
require 'input_system'
require 'spatial_system'

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

    # Using direct entities:
    # p1_lander = @entity_manager.create_named_entity('p1_lander')
    # @entity_manager.add_component p1_lander, SpatialState.new(50, 50, 0, 0)
    # @entity_manager.add_component p1_lander, Engine.new(0.01)
    # @entity_manager.add_component p1_lander, Renderable.new(RELATIVE_ROOT + "res/lander.png", 1.0, 0)
    # @entity_manager.add_component p1_lander, GravitySensitive.new
    # @entity_manager.add_component p1_lander, PlayerInput.new([Input::KEY_A,Input::KEY_D,Input::KEY_S])

    # Using "meta" entities:
    p1_lander = MetaEntity.new(@entity_manager, 'p1_lander')
    p1_lander.add_component SpatialState.new(50, 50, 0, 0)
    #p1_lander.add_component Engine.new(0.01)
    p1_lander.add_component Renderable.new(RELATIVE_ROOT + "res/lander.png", 1.0, 0)
    p1_lander.add_component GravitySensitive.new
    p1_lander.add_component PlayerInput.new([Input::KEY_A,Input::KEY_D,Input::KEY_S])

    # p2_lander = @entity_manager.create_named_entity('p2_lander')
    # @entity_manager.add_component p2_lander, SpatialState.new(250, 50, 0, 0)
    # @entity_manager.add_component p1_lander, Engine.new(0.02)
    # @entity_manager.add_component p2_lander, Renderable.new(RELATIVE_ROOT + "res/lander.png", 1.0, 0)
    # @entity_manager.add_component p2_lander, GravitySensitive.new
    # @entity_manager.add_component p2_lander, PlayerInput.new([Input::KEY_J,Input::KEY_K,Input::KEY_L])

    @entity_manager.dump_to_screen

    # Initialize any runnable systems
    @physics  = Physics.new(self)
    @input    = InputSystem.new(self)
    @renderer = Renderer.new(self)
    @systems = [@physics, @input, @renderer]

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
    @physics.process_one_game_tick(container, delta, @entity_manager)
    @input.process_one_game_tick(container, delta, @entity_manager)
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

    @renderer.process_one_game_tick(@entity_manager)
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
