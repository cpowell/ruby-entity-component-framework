##
# Copyright 2012, Prylis Incorporated.
#
# This file is part of The Ruby Entity-Component Framework.
#
# The Ruby Entity-Component Framework is free software: you can redistribute it
# and/or modify it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# The Ruby Entity-Component Framework is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser
# General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License along
# with The Ruby Entity-Component Framework.  If not, see
# <http://www.gnu.org/licenses/>.

require 'components/renderable'
require 'components/engine'

require 'systems/engine_system'

class InputSystem < System
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

    inputtable_entities = entity_mgr.get_all_entities_with_component_of_type(PlayerInput)
    inputtable_entities.each do |entity|
      input_component = entity_mgr.get_entity_component_of_type(entity, PlayerInput)

      if (input_system.is_key_down(P1_KEY_THRUST) && 
          input_component.responsive_keys.include?(P1_KEY_THRUST) && 
          entity_mgr.entity_has_component_of_type(entity, Engine)) || 
         (input_system.is_key_down(P2_KEY_THRUST) && 
          input_component.responsive_keys.include?(P2_KEY_THRUST) &&
          entity_mgr.entity_has_component_of_type(entity, Engine))

        engine_component=entity_mgr.get_entity_component_of_type(entity, Engine)
        engine_component.on=true
      end

      if (input_system.is_key_down(P1_KEY_ROTL) && 
          input_component.responsive_keys.include?(P1_KEY_ROTL)) ||
         (input_system.is_key_down(P2_KEY_ROTL) && 
          input_component.responsive_keys.include?(P2_KEY_ROTL))
          
        renderable_component=entity_mgr.get_entity_component_of_type(entity, Renderable)
        renderable_component.rotate(delta * -0.1)
      end

      if (input_system.is_key_down(P1_KEY_ROTR) && 
          input_component.responsive_keys.include?(P1_KEY_ROTR)) ||
         (input_system.is_key_down(P2_KEY_ROTR) && 
          input_component.responsive_keys.include?(P2_KEY_ROTR))
        
        renderable_component=entity_mgr.get_entity_component_of_type(entity, Renderable)
        renderable_component.rotate(delta * 0.1)
      end
    end
  end
end
