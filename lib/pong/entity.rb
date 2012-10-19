# A Entity in a game is an object that exists in the world defined by the game.
#
# This means that almost everything is a game entity, from the player character 
# to the box that holds the score. Some entities may be visible, others may be mobile, 
# but all of them are part of the world of the game (even if invisible).
class Entity
  attr_accessor :position_x, :position_y, :scale, :rotation
  attr_reader :game

  def initialize(game)
    @game = game
    @position_x = 0
    @position_y = 0
    @scale = 1.0
    @rotation = 0
  end

  def update(container, delta)
    Logger.global.log Level::SEVERE, "Entity::update must be overridden."
  end

end
