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
    user_input = container.get_input

    entities.each do |e|
      input_component      = entity_mgr.get_component(e, PlayerInput)
      renderable_component = entity_mgr.get_component(e, Renderable)

      if user_input.is_key_down(KEY_THRUST) && input_component.responsive_keys.include?(KEY_THRUST)
        location_component = entity_mgr.get_component(e, ScreenLocation)
        current_rotation   = renderable_component.rotation

        x_vector =  (THRUST*delta) * Math.sin(current_rotation * Math::PI / 180.0);
        y_vector = -(THRUST*delta) * Math.cos(current_rotation * Math::PI / 180.0);

        location_component.dy += y_vector
        location_component.dx += x_vector

        #if (@fuel > 0)
        #  @fuel -= THRUST*delta
        #  @fuel = 0 if @fuel < 0
        #end
      end

      if user_input.is_key_down(KEY_ROTL) && input_component.responsive_keys.include?(KEY_ROTL)
        renderable_component.rotate(delta * -0.1)
      end

      if user_input.is_key_down(KEY_ROTR) && input_component.responsive_keys.include?(KEY_ROTR)
        renderable_component.rotate(delta * 0.1)
      end
    end
  end
end
