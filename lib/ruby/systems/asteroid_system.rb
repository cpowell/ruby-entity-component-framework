##
# Copyright 2012, Prylis Incorporated.
#
# This file is part of The Ruby Entity-Component Framework.
# https://github.com/cpowell/ruby-entity-component-framework
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

class AsteroidSystem < System
  def process_one_game_tick(delta, entity_mgr)
    generate_new_asteroids(delta, entity_mgr)
    cleanup_asteroids(delta, entity_mgr)
  end

  def generate_new_asteroids(delta, entity_mgr)
    if rand(50)==0
      starting_x = -100
      starting_y = rand(500) - 150
      starting_dx = rand(15) + 2
      starting_dy = rand(20) - 10
      asteroid = entity_mgr.create_tagged_entity('asteroid')
      entity_mgr.add_entity_component asteroid, SpatialState.new(starting_x, starting_y, starting_dx, starting_dy)
      entity_mgr.add_entity_component asteroid, Renderable.new(RELATIVE_ROOT + "res/images/asteroid.png", 1.0, 0)
      #entity_mgr.add_entity_component asteroid, PolygonCollidable.new
      entity_mgr.add_entity_component asteroid, Motion.new
    end      
  end

  def cleanup_asteroids(delta, entity_mgr)
    asteroid_entities = entity_mgr.get_all_entities_with_tag('asteroid') || []

    asteroid_entities.each do |a|
      spatial_component = entity_mgr.get_entity_component_of_type(a, SpatialState)
      if spatial_component.x > 640
        entity_mgr.kill_entity(a)
      end
    end
  end

end

