require 'component'
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
  end

  # Future use (when Jruby gets its marshaling fixed)
  # def marshal_dump
  #   [@image_fn, @scale, @rotation]
  # end

  # def marshal_load(array)
  #   @image_fn, @scale, @rotation = array
  #   @image = Image.new(image_fn)
  # end

end
