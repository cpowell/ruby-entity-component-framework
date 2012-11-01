##
# Copyright 2012, Prylis Incorporated.
#
# This file is part of The Ruby Entity-Component Framework.
# https://github.com/cpowell/ruby-entity-component-framework
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

require 'startup_state'
require 'playing_state'

class Game < StateBasedGame
  attr_reader :game_clock

  GAME_CLOCK_MULTIPLIER=2

  def initialize(name)
    super(name)
    @game_clock = Time.utc(2000,"jan",1,20,15,1)
  end

  def run
    @@logger.debug "Game::run()"
    container = AppGameContainer.new(self)
    container.set_display_mode(640, 480, false)
    
    # Fix for super high frame rates / limit updates compared to renders:
    # A minimum interval (in ms) that has to pass since the last update() call
    # before update() is called again.
    container.setMinimumLogicUpdateInterval(20)

    # Fix for really slow frame rates / let updates 'catch up' to renders:
    # If the interval since the last update() call exceeds this value, then Slick 
    # divides the accrued time by this value and runs update() that many times
    container.setMaximumLogicUpdateInterval(50)

    container.start
  end

  def initStatesList(container)
    @@logger.debug "Game::initStatesList()"

    # The order you add them is important; starting state must be first.
    addState StartupState.new
    addState PlayingState.new
    
    # Add other states here...
  end  

  def increment_game_clock(seconds)
    @game_clock += (seconds)
  end
end

