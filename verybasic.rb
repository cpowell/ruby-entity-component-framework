$:.push File.expand_path('../lib', __FILE__)

require 'java'
require 'lwjgl.jar'
require 'slick.jar'

java_import org.newdawn.slick.BasicGame
java_import org.newdawn.slick.GameContainer
java_import org.newdawn.slick.Graphics
java_import org.newdawn.slick.Input
java_import org.newdawn.slick.SlickException
java_import org.newdawn.slick.AppGameContainer

class Demo < BasicGame
  # Due to how Java decides which method to call based on its
  # method prototype, it's good practice to fill out all necessary
  # methods even with empty definitions.
  #
  # is called when a game is started.
  def init(container)
  end

  #is called frequently by the underlying game engine. Activities related to updating game data or processing input can go here.
  def update(container, delta)
    # Grab input and exit if escape is pressed
    input = container.get_input
    container.exit if input.is_key_down(Input::KEY_ESCAPE)
  end

  # is called frequently by the underlying game engine. All activities relevant to rendering the game window go here.
  def render(container, graphics)
    graphics.draw_string('JRuby Demo (ESC to exit)', 8, container.height - 30)
  end
end

app = AppGameContainer.new(Demo.new('SlickDemo'))
app.set_display_mode(640, 480, false)
app.start
