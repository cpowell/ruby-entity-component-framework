##
# Copyright 2012, Prylis Incorporated.
#
# This file is part of The Ruby Entity-Component Framework.
# https://github.com/cpowell/ruby-entity-component-framework
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

require 'systems/system'
require 'components/renderable'
require 'components/spatial_state'

class RenderingSystem < System
  def process_one_game_tick(entity_mgr, camera, batch)
    Gdx.gl.glClearColor(0, 0, 0.2, 1)
    Gdx.gl.glClear(GL10.GL_COLOR_BUFFER_BIT)

    camera.update
    batch.setProjectionMatrix(camera.combined)

    batch.begin

    entities = entity_mgr.get_all_entities_with_components_of_type([Renderable, SpatialState])
    entities.each do |e|
      loc_comp    = entity_mgr.get_entity_component_of_type(e, SpatialState)
      render_comp = entity_mgr.get_entity_component_of_type(e, Renderable)

      #thing = Rectangle.new(loc_comp.x, loc_comp.y, render_comp.width, render_comp.height)
      
      batch.draw(render_comp.image, loc_comp.x, loc_comp.y,
        render_comp.width/2, render_comp.height/2,
        render_comp.width, render_comp.height,
        1.0, 1.0,
        render_comp.rotation,
        0, 0,
        render_comp.width, render_comp.height,
        false, false
      )
    end

    batch.end

    # entities = entity_mgr.get_all_entities_with_component_of_type(Fuel)
    # entities.each_with_index do |e, index|
    #   fuel_component   = entity_mgr.get_entity_component_of_type(e, Fuel)
    #   # graphics.draw_string("Fuel remaining #{sprintf "%.1f" % fuel_component.remaining}", 8, container.height - 30 * (index+2))
    # end

    # Uncomment to visualize the bounding polygons:
    # entities = entity_mgr.get_all_entities_with_component_of_type(PolygonCollidable)
    # entities.each_with_index do |e, index|
    #   polygon_component = entity_mgr.get_entity_component_of_type(e, PolygonCollidable)
    #   graphics.draw polygon_component.bounding_polygon if polygon_component.bounding_polygon
    # end
  end
end

