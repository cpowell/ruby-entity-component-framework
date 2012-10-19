module Renderable
  # def render(container, graphics)
  #   Logger.global.log Level::SEVERE, "Need to override this."
  # end

  attr_accessor  :image

  def render(container, graphics)
    @image.draw(@position_x, @position_y, @scale)
  end
end
