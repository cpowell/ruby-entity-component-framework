require 'forwardable'
require 'component'

java_import org.newdawn.slick.geom.Polygon
java_import org.newdawn.slick.geom.Vector2f
java_import org.newdawn.slick.geom.Transform

class Renderable < Component
  extend Forwardable
  def_delegators :@image, :width, :height  # Its image knows the dimensions.

  def initialize(image_fn, x, y, scale, rotation)
    super()
    @image = Image.new(image_fn)

    @position_x = x
    @position_y = y
    @scale      = scale
    @rotation   = rotation
  end

  def update(container, delta)
    #nop
  end

  def render(container, graphics)
    p = bounding_box
    #graphics.draw(p)
    @image.draw(@position_x, @position_y, @scale)
  end

  def rotate(amount)
    @image.rotate(amount)

    #  rotate(-0.2 * delta)
    @rotation = @image.rotation
  end

  def bounding_box
    polygon = Polygon.new
    polygon.addPoint(@position_x, @position_y)
    polygon.addPoint(@position_x + width, @position_y)
    polygon.addPoint(@position_x + width, @position_y + height)
    polygon.addPoint(@position_x, @position_y + height)

    center = Vector2f.new(@position_x + width/2.0*@scale, @position_y + height/2.0*@scale)

    rotate_transform = Transform.createRotateTransform(@rotation * Math::PI / 180.0, center.getX, center.getY)
    #scale_transform = Transform.createScaleTransform(scale, scale)

    polygon = polygon.transform(rotate_transform)
    #polygon = polygon.transform(scale_transform)

    return polygon
  end

  def intersects(other)
    return bounding_box.intersects(other.bounding_box)
  end

  def reposition_x(amount)
    @position_x += amount
  end

  def reposition_y(amount)
    @position_y += amount
  end
end
