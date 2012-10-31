##
# Copyright 2012, Prylis Incorporated.
#
# This file is part of The Ruby Entity-Component Framework.
# https://github.com/cpowell/ruby-entity-component-framework
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

class StartupState < BasicGameState
  ID = 1 # Unique ID for this Slick game state

  # Required by StateBasedGame
  def getID
    ID
  end

  # Before you start the game loop, you can initialize any data you wish inside the method init.
  #
  # * *Args*    :
  #   - +container+ -> game container that handles the game loop, fps recording and managing the input system
  #
  def init(container, game)
    @game = game
    @container = container # So I can exit later...
    container.setTargetFrameRate(60)
    container.setAlwaysRender(true)
  end

  # The update method is called during the game to update the logic in our world, 
  # within this method we can obtain the user input, calculate the world response 
  # to the input, do extra calculation like the AI of the enemies, etc. Your game logic goes here.
  #
  # * *Args*    :
  #   - +container+ -> game container that handles the game loop, fps recording and managing the input system
  #   - +delta+ -> the number of ms since update was last called. We can use it to 'weight' the changes we make.
  #
  def update(container, game, delta)
  end

  # After that the render method allows us to draw the world we designed accordingly 
  # to the variables calculated in the update method.
  #
  # * *Args*    :
  #   - +container+ -> game container that handles the game loop, fps recording and managing the input system
  #   - +graphics+ -> graphics context that can be used to render. However, normal rendering routines can also be used.
  #
  def render(container, game, graphics)
    graphics.setColor(Color.white)
    graphics.draw_string("Lunar Lander (ESC to exit)", 8, container.height - 30)
    graphics.setColor(Color.red)
    graphics.draw_string("Startup state (P to play)", 8, container.height - 200)
  end

  # Notification that a key was released
  #
  # * *Args*    :
  #   - +key+ -> the slick.Input key code that was sent
  #   - +char+ -> the ASCII decimal character-code that was sent
  #
  def keyReleased(key, char)
    if key==Input::KEY_P
      @game.enterState(PlayingState::ID, FadeOutTransition.new(Color.black), FadeInTransition.new(Color.black))
    elsif key==Input::KEY_ESCAPE
      @container.exit
    end
  end

end

