##
# Copyright 2012, Prylis Incorporated.
#
# This file is part of The Ruby Entity-Component Framework.
# https://github.com/cpowell/ruby-entity-component-framework
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

require 'state_of_game'

class Game < StateBasedGame

  def initStatesList(container)
    addState StateOfGame.new(container, self)
  end  
end

