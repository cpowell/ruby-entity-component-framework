require 'systems/system'
require 'spatial_state'

class Physics < System
  # This constant could conceivably live in the gravity component...
  ACCELERATION = 0.005 # m/s^2

  def process_one_game_tick(container, delta, entity_mgr)
    entities = entity_mgr.get_all_entities_possessing_component(GravitySensitive)

    entities.each do |e|
      loc_comp    = entity_mgr.get_component(e, SpatialState)
      grav_comp   = entity_mgr.get_component(e, GravitySensitive)

      # vertical speed will feel gravity's effect
      loc_comp.dy += ACCELERATION * delta

      # fall by dy
      direction = Math.cos(Math::PI)
      amount    = -0.01 * delta * loc_comp.dy
      loc_comp.y += (amount * direction)

      # move horizontally by dx
      amount     = 0.01 * delta * loc_comp.dx
      loc_comp.x += (amount)
    end
  end
end
