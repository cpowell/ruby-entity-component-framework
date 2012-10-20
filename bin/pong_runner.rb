# ruby -rubygems bin/pong_runner.rb 
# or
# rm -f mygame.jar && warble jar && java -jar ./mygame.jar

$:.push File.expand_path('../../lib/', __FILE__)
$:.push File.expand_path('../../lib/pong/', __FILE__)

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

require 'pong/pong_game.rb'

app = AppGameContainer.new(PongGame.new('RubyPong'))
app.set_display_mode(640, 480, false)
app.start
