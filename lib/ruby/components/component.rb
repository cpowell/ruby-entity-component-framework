class Component
  attr_reader :id

  def initialize
    @id = SecureRandom.uuid
  end

  def to_s
    "Component {#{id}: #{self.class.name}}"
  end
end
