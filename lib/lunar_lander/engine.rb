require 'forwardable'
require 'component'

class Engine < Component
  THRUST=0.01

  def initialize
    super()
  end

  def update(container, delta)
    input = container.get_input
    
    if input.is_key_down(Input::KEY_S)
      @owner.reduce_vertical_speed(THRUST*delta)
    end
  end

end
