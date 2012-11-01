##
# Copyright 2012, Prylis Incorporated.
#
# This file is part of The Ruby Entity-Component Framework.
# https://github.com/cpowell/ruby-entity-component-framework
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

require 'entity_manager'

# Necesssary components
require 'components/spatial_state'
require 'components/gravity_sensitive'
require 'components/motion'
require 'components/player_input'
require 'components/fuel'
#require 'components/polygon_collidable'
require 'components/landable'
require 'components/pad'

# Necessary systems
require 'systems/rendering_system'
require 'systems/physics'
require 'systems/input_system'
require 'systems/spatial_system'
#require 'systems/collision_system'
require 'systems/landing_system'
require 'systems/asteroid_system'

class Game
  include ApplicationListener

  attr_reader :game_clock

  GAME_CLOCK_MULTIPLIER=1

  # Method called once when the application is created.
  def create
    if File.size? 'savedgame.dat'
      #@entity_manager = YAML::load( File.open( 'savedgame.yaml' ) )
      @entity_manager = Marshal::load( File.open( 'savedgame.dat' ) )
      @entity_manager.game = self
    else
      @entity_manager = EntityManager.new(self)
  
      p1_lander = @entity_manager.create_tagged_entity('p1_lander')
      @entity_manager.add_entity_component p1_lander, SpatialState.new(580, 430, 0, 0)
      @entity_manager.add_entity_component p1_lander, Engine.new(0.01)
      @entity_manager.add_entity_component p1_lander, Fuel.new(250)
      @entity_manager.add_entity_component p1_lander, Renderable.new(RELATIVE_ROOT + "res/images/lander.png", 1.0, 0)
      @entity_manager.add_entity_component p1_lander, GravitySensitive.new
      @entity_manager.add_entity_component p1_lander, Motion.new
      #@entity_manager.add_entity_component p1_lander, PolygonCollidable.new
      @entity_manager.add_entity_component p1_lander, Landable.new
      @entity_manager.add_entity_component p1_lander, PlayerInput.new([Input::Keys::A, Input::Keys::S, Input::Keys::D])

      platform = @entity_manager.create_tagged_entity('platform')
      @entity_manager.add_entity_component platform, SpatialState.new(50, 118, 0, 0)
      @entity_manager.add_entity_component platform, Renderable.new(RELATIVE_ROOT + "res/images/shelf.png", 1.0, 0)
      @entity_manager.add_entity_component platform, Pad.new

      ground = @entity_manager.create_tagged_entity('ground')
      @entity_manager.add_entity_component ground, SpatialState.new(0, -140, 0, 0)
      @entity_manager.add_entity_component ground, Renderable.new(RELATIVE_ROOT + "res/images/ground.png", 1.0, 0)
      #@entity_manager.add_entity_component ground, PolygonCollidable.new
    end

    #@@logger.debug @entity_manager.dump_details

    Display.sync(100)

    # Initialize any runnable systems
    @physics   = Physics.new(self)
    @input     = InputSystem.new(self)
    @renderer  = RenderingSystem.new(self)
    @engine    = EngineSystem.new(self)
    #@collision = CollisionSystem.new(self)
    @landing   = LandingSystem.new(self)
    @asteroid  = AsteroidSystem.new(self)

    @bg_image = Texture.new(Gdx.files.internal(RELATIVE_ROOT + 'res/images/bg.png'))

    @game_over=false
    @landed=false
    @elapsed=0

    @game_clock = Time.utc(2000,"jan",1,20,15,1)

    @camera = OrthographicCamera.new
    @camera.setToOrtho(false, 640, 480);
    @batch = SpriteBatch.new
    @font = BitmapFont.new
  end

  # Method called by the game loop from the application every time rendering
  # should be performed. Game logic updates are usually also performed in this
  # method.
  def render
    delta=Gdx.graphics.getDeltaTime * 1000 # seconds to ms

    # This shows how to do something every N seconds:
    @elapsed += delta;
    if (@elapsed >= 1000)
      increment_game_clock(@elapsed/1000*Game::GAME_CLOCK_MULTIPLIER)
      @elapsed = 0
    end

    # Nice because I can dictate the order things are processed
    # @asteroid.process_one_game_tick(delta, @entity_manager)
    @input.process_one_game_tick(delta, @entity_manager)
    @engine.process_one_game_tick(delta, @entity_manager)
    @physics.process_one_game_tick(delta, @entity_manager)
    #@landed = @landing.process_one_game_tick(delta, @entity_manager)
    #@game_over = @collision.process_one_game_tick(container, delta, @entity_manager)

    # Make sure you "layer" things in here from bottom to top...
    @camera.update
    @batch.setProjectionMatrix(@camera.combined)

    @batch.begin

    @batch.draw(@bg_image, 0, 0)

    @renderer.process_one_game_tick(@entity_manager, @camera, @batch)

    @font.draw(@batch, "Lunar Lander (ESC to exit)", 8, 20);
    @font.draw(@batch, "Time now: #{@game_clock.to_s}", 8, 50);

    @batch.end

    # if @landed
    #   container.graphics.draw_string("Hooray you made it!", 50, 50)
    #   container.pause
    # elsif @game_over
    #   container.graphics.draw_string("BANG you're dead", 50, 50)
    #   container.pause
    # end

    if Gdx.input.isKeyPressed(Input::Keys::ESCAPE)
      Gdx.app.exit
    end

  end

  # This method is called every time the game screen is re-sized and the game is
  # not in the paused state. It is also called once just after the create()
  # method.

  # The parameters are the new width and height the screen has been resized to in
  # pixels.
  def resize width, height
  end

  # On Android this method is called when the Home button is pressed or an
  # incoming call is received. On desktop this is called just before dispose()
  # when exiting the application.

  # A good place to save the game state.
  def pause

  end

  # This method is only called on Android, when the application resumes from a
  # paused state.
  def resume

  end

  # Called when the application is destroyed. It is preceded by a call to pause().
  def dispose

  end

  def increment_game_clock(seconds)
    @game_clock += (seconds)
  end
end

# class Game < StateBasedGame
#   attr_reader :game_clock

#   GAME_CLOCK_MULTIPLIER=1

#   def initialize(name)
#     super(name)
#     @game_clock = Time.utc(2000,"jan",1,20,15,1)
#   end

#   def run
#     @@logger.debug "Game::run()"
#     container = AppGameContainer.new(self)
#     container.set_display_mode(640, 480, false)
    
#     # Fix for super high frame rates / limit updates compared to renders:
#     # A minimum interval (in ms) that has to pass since the last update() call
#     # before update() is called again.
#     container.setMinimumLogicUpdateInterval(20)

#     # Fix for really slow frame rates / let updates 'catch up' to renders:
#     # If the interval since the last update() call exceeds this value, then Slick 
#     # divides the accrued time by this value and runs update() that many times
#     container.setMaximumLogicUpdateInterval(50)

#     container.start
#   end

#   def initStatesList(container)
#     @@logger.debug "Game::initStatesList()"

#     # The order you add them is important; starting state must be first.
#     addState StartupState.new
#     addState PlayingState.new
    
#     # Add other states here...
#   end  

#   def increment_game_clock(seconds)
#     @game_clock += (seconds)
#   end
# end

