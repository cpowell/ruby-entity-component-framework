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

class Physics < System
  # This constant could conceivably live in the gravity component...
  ACCELERATION = 0.005 # m/s^2
  DOWN = Math.cos(Math::PI)

  def process_one_game_tick(container, delta, entity_mgr)

    # MetaEntity way:
    # gravity_entity_ids = entity_mgr.get_all_entities_with_component_of_type(GravitySensitive)
    # gravity_entity_ids.each do |uuid|
    #   me = MetaEntity.load_from_entity_manager(uuid)

    #   spatial_component = me.get_entity_component_of_type(SpatialState)

    #   # move horizontally according to dx
    #   amount = 0.01 * delta * spatial_component.dx
    #   spatial_component.x += (amount)

    #   # vertical speed will feel gravity's effect
    #   spatial_component.dy += ACCELERATION * delta

    #   # now fall according to dy
    #   amount = -0.01 * delta * spatial_component.dy
    #   spatial_component.y += (amount * DOWN)
    # end

    gravity_entities = entity_mgr.get_all_entities_with_component_of_type(GravitySensitive)
    gravity_entities.each do |e|
      spatial_component = entity_mgr.get_entity_component_of_type(e, SpatialState)

      # vertical speed will feel gravity's effect
      spatial_component.dy += ACCELERATION * delta
    end

    moving_entities = entity_mgr.get_all_entities_with_component_of_type(Motion)
    moving_entities.each do |e|
      spatial_component = entity_mgr.get_entity_component_of_type(e, SpatialState)

      # move horizontally according to dx
      amount = 0.01 * delta * spatial_component.dx
      spatial_component.x += (amount)

      # now fall according to dy
      amount = -0.01 * delta * spatial_component.dy
      spatial_component.y += (amount * DOWN)
    end
  end
end
