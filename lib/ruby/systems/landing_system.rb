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

class LandingSystem < System
  PIXEL_FUDGE=2
  MAX_SPEED=5

  def process_one_game_tick(container, delta, entity_mgr)
    landable_entities = entity_mgr.get_all_entities_with_component_of_type(Landable)
    pad_entities      = entity_mgr.get_all_entities_with_component_of_type(Pad)

    landable_entities.each do |entity|
      location_component   = entity_mgr.get_entity_component_of_type(entity, SpatialState)
      renderable_component = entity_mgr.get_entity_component_of_type(entity, Renderable)

      bl_x = location_component.x
      bl_y = location_component.y + renderable_component.height

      bc_x = bl_x + (renderable_component.width/2)

      br_x = bl_x + renderable_component.width
      br_y = bl_y

      pad_entities.each do |pad|
        pad_loc_component = entity_mgr.get_entity_component_of_type(pad, SpatialState)
        pad_rend_component = entity_mgr.get_entity_component_of_type(pad, Renderable)

        ul_x = pad_loc_component.x
        ul_y = pad_loc_component.y
        #puts "lander x: #{bc_x} y: #{bl_y} / Pad x: #{ul_x} y: #{ul_y}"

        ur_x = ul_x+pad_rend_component.width
        ur_y = ul_y

        if (bl_y>=ul_y-PIXEL_FUDGE && bl_y <= ul_y+PIXEL_FUDGE) && 
            ( bc_x>=ul_x && bc_x <= ur_x) &&
            ( location_component.dy <= MAX_SPEED)
          return true
        end
      end

      return false
    end
  end
end
