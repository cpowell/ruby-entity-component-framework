# ruby -rubygems bin/pong.rb 
# or just
# ruby bin/pong.rb

# rake rawr:jar
# java -jar package/jar/pong.jar

$:.push File.expand_path('../../lib/java', __FILE__)

require 'java'
require 'lwjgl.jar'
require 'slick.jar'

require 'lib/pong_game.rb'

app = AppGameContainer.new(PongGame.new('RubyPong'))
app.set_display_mode(640, 480, false)
app.start
