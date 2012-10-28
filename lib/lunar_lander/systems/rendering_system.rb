require 'systems/system'
require 'renderable'
require 'spatial_state'

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
      graphics.draw_string("Fuel remaining #{fuel_component.remaining}", 8, container.height - 30 * (index+2))
    end

    # Uncomment to visualize the bounding polygons:
    # entities = entity_mgr.get_all_entities_with_component_of_type(PolygonCollidable)
    # entities.each_with_index do |e, index|
    #   polygon_component = entity_mgr.get_entity_component_of_type(e, PolygonCollidable)
    #   graphics.draw polygon_component.bounding_polygon if polygon_component.bounding_polygon
    # end
  end
end

