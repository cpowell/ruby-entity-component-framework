#require "game_object"
require 'forwardable'

class Paddle #< GameObject
  extend Forwardable
  
  attr_accessor :x, :y, :game
  def_delegators :@image, :width, :height

  def initialize(game)
    @image = Image.new("media/paddle.png")
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
    @y = 400
  end

  def update(container, delta)
    input = container.get_input

    if input.is_key_down(Input::KEY_LEFT) and @x > 0
      @x -= 0.3 * delta
    end

    if input.is_key_down(Input::KEY_RIGHT) and @x < container.width - width
      @x += 0.3 * delta
    end
  end

end
