# ruby -J-Djava.library.path=./native -rubygems bin/runner.rb
# or
# rm -f mygame.jar && warble jar && java -Djava.library.path=./native -jar mygame.jar

$:.push File.expand_path('../../lib/', __FILE__)
$:.push File.expand_path('../../lib/ruby/', __FILE__)

# Need a different root when inside the jar, luckily $0 is "<script>" in that case
RELATIVE_ROOT = $0['<'] ? 'mygame/' : ''

require 'java'
require 'lwjgl.jar'
require 'slick.jar'

java_import org.newdawn.slick.BasicGame
java_import org.newdawn.slick.GameContainer
java_import org.newdawn.slick.Graphics
java_import org.newdawn.slick.Image
java_import org.newdawn.slick.Input
java_import org.newdawn.slick.SlickException
java_import org.newdawn.slick.AppGameContainer
java_import java.util.logging.Logger
java_import java.util.logging.Level

require 'ruby/game.rb'

app = AppGameContainer.new(Game.new('LunarLander'))
app.set_display_mode(640, 480, false)
app.start
