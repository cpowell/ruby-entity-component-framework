class Component
  attr_reader :id
  attr_accessor :owner

  def update(container, delta)
    Logger.global.log Level::SEVERE, "Component::update must be overridden."
  end
end
