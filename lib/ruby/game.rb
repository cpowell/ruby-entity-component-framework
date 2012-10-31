##
# Copyright 2012, Prylis Incorporated.
#
# This file is part of The Ruby Entity-Component Framework.
# https://github.com/cpowell/ruby-entity-component-framework
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

require 'playing_state'

class Game < StateBasedGame

  def run
    @@logger.debug "Game::run()"
    container = AppGameContainer.new(self)
    container.set_display_mode(640, 480, false)
    container.start
  end

  def initStatesList(container)
    @@logger.debug "Game::initStatesList()"
    addState PlayingState.new(container, self)
    # Add other states here...
  end  
end

