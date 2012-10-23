require 'component'
require 'forwardable'

class Renderable < Component
  extend Forwardable
  def_delegators :@image, :width, :height # Its image knows the dimensions.

  attr_accessor :image, :scale, :rotation

  def initialize(image_fn, scale, rotation)
    super()
    @image      = Image.new(image_fn)
    @scale      = scale
    @rotation   = rotation
  end

  def rotate(amount)
    @rotation += amount
    @image.rotate(amount)
  end

  def to_s
    "Renderable component {#{@image}}"
  end
end
