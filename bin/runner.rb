##
# Copyright (c) 2012, Christopher Powell.
#
# This file is part of The Ruby Entity-Component Framework.
#
# The Ruby Entity-Component Framework is free software: you can redistribute it
# and/or modify it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# The Ruby Entity-Component Framework is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser
# General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License along
# with The Ruby Entity-Component Framework.  If not, see
# <http://www.gnu.org/licenses/>.


# This class exists as a main entry point for the JRuby application,
# whether run from the .rb files or as a compiled jar.

$:.push File.expand_path('../../lib/', __FILE__)
$:.push File.expand_path('../../lib/ruby/', __FILE__)

# Need a different root when inside the jar, luckily $0 is "<script>" in that case
RELATIVE_ROOT = $0['<'] ? 'ruby_ec/' : ''

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

require 'logger'
@@logger = Logger.new(STDERR)
@@logger.level = Logger::DEBUG
@@logger.info 'This game was built using The Ruby Entity-Component Framework, Copyright 2012 Christopher Powell'

require 'game'

app = AppGameContainer.new(Game.new('LunarLander'))
app.set_display_mode(640, 480, false)
app.start
