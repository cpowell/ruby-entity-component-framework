require 'forwardable'

module Renderable
  # def render(container, graphics)
  #   Logger.global.log Level::SEVERE, "Need to override this."
  # end

  attr_accessor  :image

  extend Forwardable
  def_delegators :@image, :width, :height  # Its image knows the dimensions.

  def rotate(amount)
    @image.rotate(amount)
  end

  def render(container, graphics)
    @image.draw(@position_x, @position_y, @scale)
  end
end
