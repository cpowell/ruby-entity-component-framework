require 'systems/system'
require 'renderable'
require 'spatial_state'

class InputSystem < System
  THRUST=0.01

  # Presumably these would be DRYed into a config file...
  P1_KEY_THRUST = Input::KEY_S
  P1_KEY_ROTL   = Input::KEY_A
  P1_KEY_ROTR   = Input::KEY_D
  P2_KEY_THRUST = Input::KEY_K
  P2_KEY_ROTL   = Input::KEY_J
  P2_KEY_ROTR   = Input::KEY_L

  def process_one_game_tick(container, delta, entity_mgr)
    input_system = container.get_input

    entities = entity_mgr.get_all_entities_possessing_component(PlayerInput)
    entities.each do |e|
      input_component      = entity_mgr.get_component(e, PlayerInput)
      renderable_component = entity_mgr.get_component(e, Renderable)

      #TODO turn this into a listener

      if (input_system.is_key_down(P1_KEY_THRUST) && input_component.responsive_keys.include?(P1_KEY_THRUST)) ||
        (input_system.is_key_down(P2_KEY_THRUST) && input_component.responsive_keys.include?(P2_KEY_THRUST))

        location_component = entity_mgr.get_component(e, SpatialState)
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

      if (input_system.is_key_down(P1_KEY_ROTL) && input_component.responsive_keys.include?(P1_KEY_ROTL)) ||
        (input_system.is_key_down(P2_KEY_ROTL) && input_component.responsive_keys.include?(P2_KEY_ROTL))
        renderable_component.rotate(delta * -0.1)
      end

      if (input_system.is_key_down(P1_KEY_ROTR) && input_component.responsive_keys.include?(P1_KEY_ROTR)) ||
        (input_system.is_key_down(P2_KEY_ROTR) && input_component.responsive_keys.include?(P2_KEY_ROTR))
        renderable_component.rotate(delta * 0.1)
      end
    end
  end
end
