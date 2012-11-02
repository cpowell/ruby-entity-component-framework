##
# Copyright 2012, Prylis Incorporated.
#
# This file is part of The Ruby Entity-Component Framework.
# https://github.com/cpowell/ruby-entity-component-framework
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

java_import com.badlogic.gdx.Game

require 'playing_state'

class MyGame < Game
  include ApplicationListener

  attr_reader :game_clock

  GAME_CLOCK_MULTIPLIER=1

  def create
    # this.setScreen(new Splash(this));
    setScreen(PlayingState.new(self))
  end
end
