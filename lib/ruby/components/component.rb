class Component
  attr_reader :id

  def initialize
    @id = java.util.UUID.randomUUID().to_s  
  end

  def to_s
    "Component {#{id}: #{self.class.name}}"
  end
end
