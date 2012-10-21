require 'forwardable'
require 'component'

class ManeuveringThrusters < Component
  def initialize
    super()
  end

  def update(container, delta)
    input = container.get_input
    
    if input.is_key_down(Input::KEY_A)
      @owner.rotate(-0.2 * delta)
    elsif input.is_key_down(Input::KEY_D)
      @owner.rotate(0.2 * delta)
    end    
  end

end
