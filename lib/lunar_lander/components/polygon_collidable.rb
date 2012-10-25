require 'component'

class PolygonCollidable < Component
  attr_accessor :bounding_polygon

  # def initialize(pos_x, width, pos_y, height, rotation, scale)
  #   super()
  #   @polygon = Polygon.new
  #   @polygon.addPoint(position_x, position_y)
  #   @polygon.addPoint(position_x + width, position_y)
  #   @polygon.addPoint(position_x + width, position_y + height)
  #   @polygon.addPoint(position_x, position_y + height)

  #   center = Vector2f.new(position_x + width/2.0*scale, position_y + height/2.0*scale)

  #   rotate_transform = Transform.createRotateTransform(rotation * Math::PI / 180.0, center.getX, center.getY)
  #   #scale_transform = Transform.createScaleTransform(scale, scale)

  #   @polygon = @polygon.transform(rotate_transform)
  #   #polygon = polygon.transform(scale_transform)
  # end
end
