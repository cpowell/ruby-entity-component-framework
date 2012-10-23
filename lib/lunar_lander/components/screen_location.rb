require 'component'

class ScreenLocation < Component
  attr_accessor :x, :y, :dx, :dy

  def initialize(x_pos, y_pos)
    super()
    @x=x_pos
    @y=y_pos
    @dx=0
    @dy=0
  end

  def to_s
    "ScreenLocation component {#{x}, #{y}}"
  end
end
