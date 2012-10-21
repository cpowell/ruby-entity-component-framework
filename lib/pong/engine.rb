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
      @owner.components.each do |c|
        if c.respond_to?(:vertical_speed)
          c.vertical_speed = c.vertical_speed - (THRUST * delta)
        end
      end
    end
  end

end
