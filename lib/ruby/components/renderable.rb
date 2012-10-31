##
# Copyright 2012, Prylis Incorporated.
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

require 'components/component'
require 'forwardable'

class Renderable < Component
  extend Forwardable
  def_delegators :@image, :width, :height # Its image knows the dimensions.

  attr_accessor :image, :image_fn, :scale, :rotation

  def initialize(image_fn, scale, rotation)
    super()
    @image_fn   = image_fn
    @image      = Image.new(image_fn)
    @scale      = scale
    @rotation   = rotation
  end

  def rotate(amount)
    @rotation += amount
    @image.rotate(amount)
  end

  # Deprecated in Ruby 1.9
  # def to_yaml_properties
  #   ['@image_fn', '@scale', '@rotation']
  # end
  def encode_with(coder)
    coder['image_fn'] = @image_fn
    coder['scale']    = @scale
    coder['rotation'] = @rotation
  end
  def init_with(coder)
    @image_fn = coder['image_fn']
    @scale    = coder['scale']
    @rotation = coder['rotation']
    @image    = Image.new(image_fn)
    @image.setRotation(@rotation)
  end

  def marshal_dump
    [@id, @image_fn, @scale, @rotation]
  end

  def marshal_load(array)
    @id, @image_fn, @scale, @rotation = array
    @image = Image.new(image_fn)
    @image.setRotation(@rotation)
  end

end
