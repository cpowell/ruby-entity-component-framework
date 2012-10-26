require 'renderable'
require 'engine'

require 'engine_system'

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
    #TODO turn this into a listener
    input_system = container.get_input

    inputtable_entities = entity_mgr.get_all_entities_possessing_component_of_type(PlayerInput)
    inputtable_entities.each do |entity|
      input_component = entity_mgr.get_component(entity, PlayerInput)

      if (input_system.is_key_down(P1_KEY_THRUST) && 
          input_component.responsive_keys.include?(P1_KEY_THRUST) && 
          entity_mgr.has_component_type(entity, Engine)) || 
         (input_system.is_key_down(P2_KEY_THRUST) && 
          input_component.responsive_keys.include?(P2_KEY_THRUST) &&
          entity_mgr.has_component_type(entity, Engine))

        engine_component=entity_mgr.get_component(entity, Engine)
        engine_component.on=true
      end

      if (input_system.is_key_down(P1_KEY_ROTL) && 
          input_component.responsive_keys.include?(P1_KEY_ROTL)) ||
         (input_system.is_key_down(P2_KEY_ROTL) && 
          input_component.responsive_keys.include?(P2_KEY_ROTL))
          
        renderable_component=entity_mgr.get_component(entity, Renderable)
        renderable_component.rotate(delta * -0.1)
      end

      if (input_system.is_key_down(P1_KEY_ROTR) && 
          input_component.responsive_keys.include?(P1_KEY_ROTR)) ||
         (input_system.is_key_down(P2_KEY_ROTR) && 
          input_component.responsive_keys.include?(P2_KEY_ROTR))
        
        renderable_component=entity_mgr.get_component(entity, Renderable)
        renderable_component.rotate(delta * 0.1)
      end
    end
  end
end
