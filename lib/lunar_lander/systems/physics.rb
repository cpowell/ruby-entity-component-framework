require 'systems/system'
require 'renderable'
require 'screen_location'

class Physics < System
  ACCELERATION = 0.005 # m/s^2

  def process_one_game_tick(container, delta, entity_mgr)
    entities = entity_mgr.get_all_entities_possessing_component(GravitySensitive)

    entities.each do |e|
      loc_comp    = entity_mgr.get_component(e, ScreenLocation)
      grav_comp   = entity_mgr.get_component(e, GravitySensitive)

      # feel gravity's effect
      loc_comp.dy += ACCELERATION * delta

      # fall
      direction = Math.cos(Math::PI)
      amount    = -0.01 * delta * loc_comp.dy
      loc_comp.y += (amount * direction)

      amount     = 0.01 * delta * loc_comp.dx
      loc_comp.x += (amount)
    end
  end
end
