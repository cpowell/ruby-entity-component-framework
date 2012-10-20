require 'forwardable'

java_import org.newdawn.slick.geom.Polygon
java_import org.newdawn.slick.geom.Vector2f
java_import org.newdawn.slick.geom.Transform

module Renderable
  attr_accessor  :image

  extend Forwardable
  def_delegators :image, :width, :height  # Its image knows the dimensions.

  def rotate(amount)
    image.rotate(amount)
  end

  def render(container, graphics)
    p = bounding_box
    graphics.draw(p)
    image.draw(position_x, position_y, scale)
  end

  # public static Polygon toPolygon(Vector2f position, Vector2f size, float rotation, float scale) {
#         Polygon polygon = new Polygon(toPoints(position, size));
#         Vector2f centre = new Vector2f(position.getX() + size.getX() / 2.0f, position.getY() + size.getY() / 2.0f);
#         Transform rotateTransform = Transform.createRotateTransform(MathUtils.toRadians(rotation), centre.getX(), centre.getY());
#         Transform scaleTransform = Transform.createScaleTransform(scale, scale);
#         polygon = (Polygon) polygon.transform(rotateTransform);
#         polygon = (Polygon) polygon.transform(scaleTransform);
#         return polygon;
# }

  def bounding_box
    polygon = Polygon.new
    polygon.addPoint(position_x - width/2.0*scale, position_y - height/2.0*scale)
    polygon.addPoint(position_x + width/2.0*scale, position_y - height/2.0*scale)
    polygon.addPoint(position_x + width/2.0*scale, position_y + height/2.0*scale)
    polygon.addPoint(position_x - width/2.0*scale, position_y + height/2.0*scale)

    center = Vector2f.new(position_x + width/2.0*scale, position_y + height/2.0*scale)

    rotate_transform = Transform.createRotateTransform(rotation * Math::PI / 180.0, center.getX, center.getY)
    #scale_transform = Transform.createScaleTransform(scale, scale)

    polygon = polygon.transform(rotate_transform)
    #polygon = polygon.transform(scale_transform)

    return polygon
  end
end
