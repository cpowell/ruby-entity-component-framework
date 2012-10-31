##
# Copyright 2012, Prylis Incorporated.
#
# This file is part of The Ruby Entity-Component Framework.
# https://github.com/cpowell/ruby-entity-component-framework
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

require 'components/component'

class SpatialState < Component
  attr_accessor :x, :y, :dx, :dy

  def initialize(x_pos, y_pos, x_velo, y_velo)
    super()
    @x  = x_pos
    @y  = y_pos
    @dx = x_velo
    @dy = y_velo
  end

end
