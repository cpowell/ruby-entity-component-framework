##
# Copyright 2012, Prylis Incorporated.
#
# This file is part of The Ruby Entity-Component Framework.
# https://github.com/cpowell/ruby-entity-component-framework
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

# A ‘System’ is simply an object that reads and updates the data
# in any relevant components. You could say it’s simply the update function of
# the relevant components refactored into its own object.
#
# Instead of the game iterating imperatively through all of the entities and
# updating each in turn, the systems take more of a functional programming
# approach. Each system specifies a set of components that it’s interested in,
# and then in each frame it processes only those entities that contain all
# specified components.
#
# Furthermore, each system exists to perform a specific role, updating all
# instances of the relevant components before passing control to the next
# system. You could say that the components are processed in cross-sections
# across all entities at once, rather than entities (and all of their child
# components) being processed in chunks.
#
class System
  attr_reader :game
  
  def initialize(game)
    @game = game
  end

  def process_one_game_tick
    raise RuntimeError, "systems must override process_one_game_tick()"
  end
end
