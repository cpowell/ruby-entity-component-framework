##
# Copyright 2012, Prylis Incorporated.
#
# This file is part of The Ruby Entity-Component Framework.
# https://github.com/cpowell/ruby-entity-component-framework
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

require 'systems/system'
require 'components/spatial_state'

class SpatialSystem < System
  def process_one_game_tick(container, delta, entity_mgr)
    #nop
  end
end
