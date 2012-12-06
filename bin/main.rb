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
RELATIVE_ROOT = $0['<'] ? 'ecs_game/' : ''

require 'java'
require "gdx-backend-lwjgl-natives.jar"
require "gdx-backend-lwjgl.jar"
require "gdx-natives.jar"
require "gdx.jar"

java_import com.badlogic.gdx.ApplicationListener
java_import com.badlogic.gdx.Gdx
java_import com.badlogic.gdx.Input
java_import com.badlogic.gdx.graphics.GL10
java_import com.badlogic.gdx.graphics.Texture
java_import com.badlogic.gdx.graphics.OrthographicCamera
java_import com.badlogic.gdx.graphics.g2d.SpriteBatch
java_import com.badlogic.gdx.graphics.g2d.BitmapFont

java_import com.badlogic.gdx.backends.lwjgl.LwjglApplication
java_import com.badlogic.gdx.backends.lwjgl.LwjglApplicationConfiguration

require 'my_game'
require 'logger'

# Think of the following as the equivalent to the stuff you'd find in the
# Java world's "public static void main(String[] argv)" method.

@@logger = Logger.new(STDERR) # or ("log.txt")
@@logger.level = Logger::DEBUG
@@logger.info 'Uses The Ruby Entity-Component Framework, Copyright 2012 Prylis Inc.'
@@logger.info 'See https://github.com/cpowell/ruby-entity-component-framework'
@@logger.info 'Please preserve this notice in your own games. Thanks for playing fair!'

cfg = LwjglApplicationConfiguration.new
cfg.title = "LunarLander"
cfg.useGL20 = true
cfg.width = 640
cfg.height = 480
LwjglApplication.new(MyGame.new, cfg)
