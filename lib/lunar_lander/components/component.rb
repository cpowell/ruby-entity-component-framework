class Component
  attr_reader :id
  attr_accessor :owner

  def initialize
    @id = rand(5000) # sucks, i know
  end

  def update(container, delta)
    Logger.global.log Level::SEVERE, "Component::update must be overridden."
  end

  def to_s
    "Component {#{id}}"
  end
end
