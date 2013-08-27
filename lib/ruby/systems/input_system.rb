##
# Copyright 2012, Prylis Incorporated.
#
# This file is part of The Ruby Entity-Component Framework.
# https://github.com/cpowell/ruby-entity-component-framework
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

require 'components/renderable'
require 'components/engine'

require 'systems/engine_system'

class InputSystem < System
  # Presumably these would be DRYed into a config file...
  P1_KEY_THRUST = Input::Keys::S
  P1_KEY_ROTL   = Input::Keys::A
  P1_KEY_ROTR   = Input::Keys::D
  P2_KEY_THRUST = Input::Keys::K
  P2_KEY_ROTL   = Input::Keys::J
  P2_KEY_ROTR   = Input::Keys::L

  def process_one_game_tick(delta, entity_mgr)
    inputtable_entities = entity_mgr.get_all_entities_with_component_of_type(PlayerInput)
    inputtable_entities.each do |entity|
      input_component = entity_mgr.get_component_of_type(entity, PlayerInput)

      if Gdx.input.isKeyPressed(P1_KEY_THRUST) &&
          input_component.responsive_keys.include?(P1_KEY_THRUST) &&
          entity_mgr.has_component_of_type?(entity, Engine)
        engine_component=entity_mgr.get_component_of_type(entity, Engine)
        engine_component.on=true
      end

      if Gdx.input.isKeyPressed(P1_KEY_ROTL) &&
          input_component.responsive_keys.include?(P1_KEY_ROTL)

        renderable_component=entity_mgr.get_component_of_type(entity, Renderable)
        renderable_component.rotate(delta * 0.1)
      end

      if Gdx.input.isKeyPressed(P1_KEY_ROTR) &&
          input_component.responsive_keys.include?(P1_KEY_ROTR)

        renderable_component=entity_mgr.get_component_of_type(entity, Renderable)
        renderable_component.rotate(delta * -0.1)
      end
    end
  end
end
