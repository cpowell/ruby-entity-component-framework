require 'systems/system'
require 'spatial_state'

class Physics < System
  # This constant could conceivably live in the gravity component...
  ACCELERATION = 0.005 # m/s^2
  DOWN = Math.cos(Math::PI)

  def process_one_game_tick(container, delta, entity_mgr)
    gravity_entities = entity_mgr.get_all_entities_possessing_component(GravitySensitive)

    gravity_entities.each do |e|
      spatial_component = entity_mgr.get_component(e, SpatialState)

      # vertical speed will feel gravity's effect
      spatial_component.dy += ACCELERATION * delta

      # now fall according to dy
      amount = -0.01 * delta * spatial_component.dy
      @game.broadcast_systems_message(:alter_y_position, e, amount*DOWN)

      # move horizontally according to dx
      amount = 0.01 * delta * spatial_component.dy
      @game.broadcast_systems_message(:alter_x_position, e, amount)
    end
  end
end
