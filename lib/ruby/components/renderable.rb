##
# Copyright 2012, Prylis Incorporated.
#
# This file is part of The Ruby Entity-Component Framework.
# https://github.com/cpowell/ruby-entity-component-framework
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

require 'components/component'
require 'forwardable'

class Renderable < Component
  extend Forwardable
  def_delegators :@image, :width, :height # Its image knows the dimensions.

  attr_accessor :image, :image_fn, :scale, :rotation

  def initialize(image_fn, scale, rotation)
    super()
    @image_fn   = image_fn
    @image      = Texture.new(Gdx.files.internal(image_fn))
    @scale      = scale
    @rotation   = rotation
  end

  def rotate(amount)
    @rotation += amount
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
    @image    = Texture.new(Gdx.files.internal(image_fn))
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
