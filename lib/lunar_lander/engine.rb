require 'forwardable'
require 'component'

class Engine < Component
  THRUST=0.01

  def initialize(fuel_qty)
    super()
    @fuel = fuel_qty
  end

  def update(container, delta)
    input = container.get_input
    
    if input.is_key_down(Input::KEY_S)
      if (@fuel > 0)
        @fuel -= THRUST*delta
        @fuel = 0 if @fuel < 0
        @owner.reduce_vertical_speed(THRUST*delta)
      end
    end
  end

  def render(container, graphics)
    graphics.draw_string("Fuel remaining: #{@fuel}", 8, container.height - 60)
  end

end
