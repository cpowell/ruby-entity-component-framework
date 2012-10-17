#require "game_object"
require "forwardable"

class Ball #< GameObject
  extend Forwardable

  attr_accessor :angle
  def_delegators :game, :paddle

  attr_accessor :x, :y, :game

  def_delegators :@image, :width, :height

  def initialize(game)
    @image = Image.new("media/ball.png")
    @game = game
    reset
  end

  def reset
  end

  def render(container, graphics)
    @image.draw(@x, @y)
  end

  def reset
    @x = 200
    @y = 200
    @angle = 0.25
  end

  def update(container, delta)
    @x += 0.3 * delta * Math.cos(@angle * Math::PI)
    @y -= 0.3 * delta * Math.sin(@angle * Math::PI)

    if (@x > container.width - width) || (@y < 0) || (@x < 0)
      @angle = (@angle + 0.5) % 2
    end

    if @y > container.height
      game.reset
    end

    if @y + height > paddle.y and
       @x < paddle.x + paddle.width and
       @x + width > paddle.x
      @angle = (@angle + 0.5 + rand(0.2) - 0.1) % 2
    end
  end

end
