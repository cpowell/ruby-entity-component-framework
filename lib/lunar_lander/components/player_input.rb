require 'component'

class PlayerInput < Component
  attr_reader :responsive_keys

  def initialize(keys)
    super()
    @responsive_keys=keys  
  end
end
