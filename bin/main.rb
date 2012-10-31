##
# Copyright 2012, Prylis Incorporated.
#
# This file is part of The Ruby Entity-Component Framework.
# https://github.com/cpowell/ruby-entity-component-framework
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.


# This class exists as a main entry point for the JRuby application,
# whether run from the .rb files or as a compiled jar.

$:.push File.expand_path('../../lib/', __FILE__)
$:.push File.expand_path('../../lib/ruby/', __FILE__)

# Need a different root when inside the jar, luckily $0 is "<script>" in that case
RELATIVE_ROOT = $0['<'] ? 'ruby_ec/' : ''

require 'java'
require 'lwjgl.jar'
require 'slick.jar'

java_import org.newdawn.slick.state.BasicGameState
java_import org.newdawn.slick.state.GameState
java_import org.newdawn.slick.state.StateBasedGame
java_import org.newdawn.slick.GameContainer
java_import org.newdawn.slick.Graphics
java_import org.newdawn.slick.Image
java_import org.newdawn.slick.Input
java_import org.newdawn.slick.SlickException
java_import org.newdawn.slick.AppGameContainer
java_import org.newdawn.slick.util.Log # supports info, debug, warn, and error

require 'game'
require 'logger'

# Think of the following as the equivalent to the Java world's 
# "public static void main(String[] argv)" method.
 
Log.setVerbose false # If set to false, info and debug messages will not be printed.

@@logger = Logger.new(STDERR) # or ("log.txt")
@@logger.level = Logger::DEBUG
@@logger.info 'This game was built using The Ruby Entity-Component Framework, Copyright 2012 Christopher Powell'
@@logger.info 'Please preserve this notice in your own games. Thanks for playing fair!'

container = AppGameContainer.new(Game.new('LunarLander'))
container.set_display_mode(640, 480, false)
container.start
