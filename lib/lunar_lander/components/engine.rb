require 'component'

class Engine < Component
  #attr_accessor :fuel
  attr_accessor :thrust

  def initialize(thrust)
    super()
    @thrust=thrust
  end
end
