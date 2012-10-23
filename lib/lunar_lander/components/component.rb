class Component
  attr_reader :id

  def initialize
    @id = rand(5000) # FIXME
  end

  def to_s
    "Component {#{id}: #{class_name}}"
  end
end
