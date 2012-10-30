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

require 'systems/system'
require 'components/renderable'
require 'components/spatial_state'

class RenderingSystem < System
  def process_one_game_tick(entity_mgr, container, graphics)
    entities = entity_mgr.get_all_entities_with_components_of_type([Renderable, SpatialState])
    entities.each do |e|
      loc_comp    = entity_mgr.get_entity_component_of_type(e, SpatialState)
      render_comp = entity_mgr.get_entity_component_of_type(e, Renderable)

      render_comp.image.draw(loc_comp.x, loc_comp.y, render_comp.scale)
    end

    entities = entity_mgr.get_all_entities_with_component_of_type(Fuel)
    entities.each_with_index do |e, index|
      fuel_component   = entity_mgr.get_entity_component_of_type(e, Fuel)
      graphics.draw_string("Fuel remaining #{sprintf "%.1f" % fuel_component.remaining}", 8, container.height - 30 * (index+2))
    end

    # Uncomment to visualize the bounding polygons:
    # entities = entity_mgr.get_all_entities_with_component_of_type(PolygonCollidable)
    # entities.each_with_index do |e, index|
    #   polygon_component = entity_mgr.get_entity_component_of_type(e, PolygonCollidable)
    #   graphics.draw polygon_component.bounding_polygon if polygon_component.bounding_polygon
    # end
  end
end

