require 'component'

class Engine < Component
  #attr_accessor :fuel
  attr_accessor :thrust
  attr_accessor :on

  def initialize(thrust)
    super()
    @thrust=thrust
    @on=false
  end
end
