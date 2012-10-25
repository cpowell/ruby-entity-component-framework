require 'systems/system'
require 'renderable'
require 'spatial_state'

class RenderingSystem < System
  def process_one_game_tick(entity_mgr, container, graphics)
    entities = entity_mgr.get_all_entities_possessing_component(Renderable)

    entities.each do |e|
      loc_comp    = entity_mgr.get_component(e, SpatialState)
      render_comp = entity_mgr.get_component(e, Renderable)

      render_comp.image.draw(loc_comp.x, loc_comp.y, render_comp.scale)
    end

    entities = entity_mgr.get_all_entities_possessing_component(Fuel)
    entities.each_with_index do |e, index|
      fuel_component   = entity_mgr.get_component(e, Fuel)
      graphics.draw_string("Fuel remaining #{fuel_component.remaining}", 8, container.height - 30 * (index+2))
    end

    entities = entity_mgr.get_all_entities_possessing_component(PolygonCollidable)
    entities.each_with_index do |e, index|
      polygon_component = entity_mgr.get_component(e, PolygonCollidable)
      graphics.draw polygon_component.bounding_polygon if polygon_component.bounding_polygon
    end
  end
end

