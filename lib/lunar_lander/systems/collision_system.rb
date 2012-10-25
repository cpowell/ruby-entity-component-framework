require 'renderable'

java_import org.newdawn.slick.geom.Polygon
java_import org.newdawn.slick.geom.Vector2f
java_import org.newdawn.slick.geom.Transform

class CollisionSystem < System

  def process_one_game_tick(container, delta, entity_mgr)
    collidable_entities = entity_mgr.get_all_entities_possessing_component(PolygonCollidable)

    # Naive O(n^2)
    polygons=[]
    collidable_entities.each do |e|
      spatial_component = entity_mgr.get_component(e, SpatialState)
      renderable_component = entity_mgr.get_component(e, Renderable)

      polygons << make_polygon(spatial_component.x, 
                                renderable_component.width,
                                spatial_component.y, 
                                renderable_component.height, 
                                renderable_component.rotation, 
                                renderable_component.scale)
    end

    for poly_1 in polygons
      for poly_2 in polygons
        if poly_1 != poly_2 && poly_1.intersects(poly_2)
          puts 'intersection'
        end
      end
    end
  end

  def intersects(polygon_1, polygon_2)
    return polygon_1.intersects(polygon_2)
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
