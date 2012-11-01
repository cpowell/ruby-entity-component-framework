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

Dir["lib/\*.jar"].each { |jar| require jar }

java_import com.badlogic.gdx.ApplicationListener

java_import com.badlogic.gdx.Gdx
java_import com.badlogic.gdx.graphics.GL10
java_import com.badlogic.gdx.graphics.Mesh
java_import com.badlogic.gdx.graphics.VertexAttribute
java_import com.badlogic.gdx.graphics.VertexAttributes

java_import com.badlogic.gdx.backends.lwjgl.LwjglApplication

require 'game'
require 'logger'

# Think of the following as the equivalent to the stuff you'd find in the
# Java world's "public static void main(String[] argv)" method.

# TODO might move these into Game
@@logger = Logger.new(STDERR) # or ("log.txt")
@@logger.level = Logger::DEBUG
@@logger.info 'Uses The Ruby Entity-Component Framework, Copyright 2012 Prylis Inc.'
@@logger.info 'See https://github.com/cpowell/ruby-entity-component-framework'
@@logger.info 'Please preserve this notice in your own games. Thanks for playing fair!'

LwjglApplication.new(Game.new, "LunarLander", 640, 480, false)
