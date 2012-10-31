##
# Copyright (c) 2012, Christopher Powell.
#
# This file is part of The Ruby Entity-Component Framework.
#
# The Ruby Entity-Component Framework is free software: you can redistribute it
# and/or modify it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# The Ruby Entity-Component Framework is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser
# General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License along
# with The Ruby Entity-Component Framework.  If not, see
# <http://www.gnu.org/licenses/>.

require "yaml"

require 'entity_manager'

# Necesssary components
require 'components/spatial_state'
require 'components/gravity_sensitive'
require 'components/motion'
require 'components/player_input'
require 'components/fuel'
require 'components/polygon_collidable'
require 'components/landable'
require 'components/pad'

# Necessary systems
require 'systems/rendering_system'
require 'systems/physics'
require 'systems/input_system'
require 'systems/spatial_system'
require 'systems/collision_system'
require 'systems/landing_system'
require 'systems/asteroid_system'

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

    if File.size? 'savedgame.dat'
      #@entity_manager = YAML::load( File.open( 'savedgame.yaml' ) )
      @entity_manager = Marshal::load( File.open( 'savedgame.dat' ) )
      @entity_manager.game = self
    else
      @entity_manager = EntityManager.new(self)
  
      p1_lander = @entity_manager.create_tagged_entity('p1_lander')
      @entity_manager.add_entity_component p1_lander, SpatialState.new(container.width-50, 50, 0, 0)
      @entity_manager.add_entity_component p1_lander, Engine.new(0.01)
      @entity_manager.add_entity_component p1_lander, Fuel.new(250)
      @entity_manager.add_entity_component p1_lander, Renderable.new(RELATIVE_ROOT + "res/images/lander.png", 1.0, 0)
      @entity_manager.add_entity_component p1_lander, GravitySensitive.new
      @entity_manager.add_entity_component p1_lander, Motion.new
      @entity_manager.add_entity_component p1_lander, PolygonCollidable.new
      @entity_manager.add_entity_component p1_lander, Landable.new
      @entity_manager.add_entity_component p1_lander, PlayerInput.new([Input::KEY_A,Input::KEY_D,Input::KEY_S])

      platform = @entity_manager.create_tagged_entity('platform')
      @entity_manager.add_entity_component platform, SpatialState.new(50, container.height - 124, 0, 0)
      @entity_manager.add_entity_component platform, Renderable.new(RELATIVE_ROOT + "res/images/shelf.png", 1.0, 0)
      @entity_manager.add_entity_component platform, Pad.new

      ground = @entity_manager.create_tagged_entity('ground')
      @entity_manager.add_entity_component ground, SpatialState.new(0, container.height - 118, 0, 0)
      @entity_manager.add_entity_component ground, Renderable.new(RELATIVE_ROOT + "res/images/ground.png", 1.0, 0)
      @entity_manager.add_entity_component ground, PolygonCollidable.new
    end

    @@logger.debug @entity_manager.dump_details

    # Initialize any runnable systems
    @physics   = Physics.new(self)
    @input     = InputSystem.new(self)
    @renderer  = RenderingSystem.new(self)
    @engine    = EngineSystem.new(self)
    @collision = CollisionSystem.new(self)
    @landing   = LandingSystem.new(self)
    @asteroid  = AsteroidSystem.new(self)

    @bg = Image.new(RELATIVE_ROOT + 'res/images/bg.png')
    
    @game_over=false
    @landed=false
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
    if input.is_key_down(Input::KEY_ESCAPE)
      if !@game_over && !@landed
        # File.open("savedgame.yaml", "w") do |file|
        #   file.puts YAML::dump(@entity_manager)
        # end
        File.open("savedgame.dat", "w") do |file|
          file.print Marshal::dump(@entity_manager)
        end
      end
      container.exit 
    end

    # Nice because I can dictate the order things are processed
    @asteroid.process_one_game_tick(container, delta, @entity_manager)
    @input.process_one_game_tick(container, delta, @entity_manager)
    @engine.process_one_game_tick(container, delta, @entity_manager)
    @physics.process_one_game_tick(container, delta, @entity_manager)
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

