# A Entity in a game is an object that exists in the world defined by the game.
#
# This means that almost everything is a game entity, from the player character 
# to the box that holds the score. Some entities may be visible, others may be mobile, 
# but all of them are part of the world of the game (even if invisible).
class Entity
  attr_reader :game

  def initialize(game)
    @id         = rand(5000) # sucks, i know
    @game       = game
    @components = []
  end

  def add_component(component)
    component.owner = self
    @components << component
  end

  def get_component(id)
    @components.detect {|comp| comp.id==id}
  end

  def update(container, delta)
    @components.each do |c|
      c.update(container, delta)
    end
  end

  def render(container, graphics)
    @components.each do |c|
      if c.respond_to?(:render)
        c.render(container,graphics)
      end
    end
  end

  # id is the name of the method called, the * syntax collects
  # all the arguments in an array named 'arguments'
  def method_missing( id, *arguments )
    #puts "Method #{id} was called, but not found. It has these arguments: #{arguments.join(", ")}"
    @components.each do |c|
      if c.respond_to?(id)
        c.send id, *arguments
      end
    end
  end

  def to_s
    "Entity {#{id}}"
  end
end
