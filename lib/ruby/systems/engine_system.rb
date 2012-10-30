##
# Copyright (c) 2012, Christopher Powell.
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

class EngineSystem < System

  def process_one_game_tick(container, delta, entity_mgr)
    engine_entities = entity_mgr.get_all_entities_with_component_of_type(Engine)
    engine_entities.each do |entity|
      engine_component = entity_mgr.get_entity_component_of_type(entity, Engine)
      fuel_component   = entity_mgr.get_entity_component_of_type(entity, Fuel)

      if engine_component.on && fuel_component.remaining > 0
        location_component   = entity_mgr.get_entity_component_of_type(entity, SpatialState)
        renderable_component = entity_mgr.get_entity_component_of_type(entity, Renderable)

        amount = engine_component.thrust*delta
        fuel_component.burn(amount)
        current_rotation   = renderable_component.rotation

        x_vector =  amount * Math.sin(current_rotation * Math::PI / 180.0);
        y_vector = -amount * Math.cos(current_rotation * Math::PI / 180.0);

        location_component.dy += y_vector
        location_component.dx += x_vector

        engine_component.on=false
      end
    end
  end
end
