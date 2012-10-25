require 'renderable'

java_import org.newdawn.slick.geom.Polygon
java_import org.newdawn.slick.geom.Vector2f
java_import org.newdawn.slick.geom.Transform

class CollisionSystem < System

  def process_one_game_tick(container, delta, entity_mgr)
    collidable_entities=[]

    polygon_entities = entity_mgr.get_all_entities_possessing_component(PolygonCollidable)
    update_bounding_polygons(entity_mgr, polygon_entities)
    collidable_entities += polygon_entities

    # circle_entities = ...
    # update_bounding_circles(circle_entities)
    # collidable_entites += circle_entities

    bounding_areas={}
    collidable_entities.each do |e| 
      bounding_areas[e]=entity_mgr.get_component(e, PolygonCollidable).bounding_polygon
    end

    # Naive O(n^2)
    bounding_areas.each_key do |entity|
      bounding_areas.each_key do |other|
        next if entity==other

        if bounding_areas[entity].intersects bounding_areas[other]
          puts "BANG: #{entity} and #{other}"
        end
      end
    end
  end

  def update_bounding_circles(entities)
    # placeholder for thought
  end

  def update_bounding_polygons(entity_mgr, entities)
    entities.each do |e|
      spatial_component    = entity_mgr.get_component(e, SpatialState)
      renderable_component = entity_mgr.get_component(e, Renderable)
      collidable_component = entity_mgr.get_component(e, PolygonCollidable)

      collidable_component.bounding_polygon = 
                   make_polygon(spatial_component.x, 
                                renderable_component.width,
                                spatial_component.y, 
                                renderable_component.height, 
                                renderable_component.rotation, 
                                renderable_component.scale)
    end
  end

  def make_polygon(position_x, width, position_y, height, rotation, scale)
    polygon = Polygon.new
    polygon.addPoint(position_x, position_y)
    polygon.addPoint(position_x + width, position_y)
    polygon.addPoint(position_x + width, position_y + height)
    polygon.addPoint(position_x, position_y + height)

    center = Vector2f.new(position_x + width/2.0*scale, position_y + height/2.0*scale)

    rotate_transform = Transform.createRotateTransform(rotation * Math::PI / 180.0, center.getX, center.getY)
    #scale_transform = Transform.createScaleTransform(scale, scale)

    polygon = polygon.transform(rotate_transform)
    #polygon = polygon.transform(scale_transform)
  end
end
