require 'systems/system'
require 'renderable'
require 'screen_location'

class InputSystem < System
  THRUST=0.01

  # Presumably these would be DRYed into a config file...
  KEY_THRUST = Input::KEY_S
  KEY_ROTL   = Input::KEY_A
  KEY_ROTR   = Input::KEY_D

  def process_one_game_tick(container, delta, entity_mgr)
    entities = entity_mgr.get_all_entities_possessing_component(PlayerInput)
    input = container.get_input

    entities.each do |e|
      input_comp = entity_mgr.get_component(e, PlayerInput)
      loc_comp   = entity_mgr.get_component(e, ScreenLocation)
      rend_comp  = entity_mgr.get_component(e, Renderable)

      if input.is_key_down(KEY_THRUST)
        current_rotation = rend_comp.rotation

        x_vector = (THRUST*delta/50) * Math.sin(current_rotation * Math::PI / 180.0);
        y_vector = -(THRUST*delta) * Math.cos(current_rotation * Math::PI / 180.0);

        loc_comp.dy += y_vector
        loc_comp.dx += x_vector

        #if (@fuel > 0)
        #  @fuel -= THRUST*delta
        #  @fuel = 0 if @fuel < 0
        #end
      end

      if input.is_key_down(KEY_ROTL)
        rend_comp.rotate(delta * -0.1)
      end
      
      if input.is_key_down(KEY_ROTR)
        rend_comp.rotate(delta * 0.1)
      end
    end
  end
end
