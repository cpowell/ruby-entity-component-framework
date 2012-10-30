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

# A ‘System’ is simply an object that reads and updates the data
# in any relevant components. You could say it’s simply the update function of
# the relevant components refactored into its own object.
#
# Instead of the game iterating imperatively through all of the entities and
# updating each in turn, the systems take more of a functional programming
# approach. Each system specifies a set of components that it’s interested in,
# and then in each frame it processes only those entities that contain all
# specified components.
#
# Furthermore, each system exists to perform a specific role, updating all
# instances of the relevant components before passing control to the next
# system. You could say that the components are processed in cross-sections
# across all entities at once, rather than entities (and all of their child
# components) being processed in chunks.
#
class System
  attr_reader :name
  
  def initialize(game)
    @game = game
  end

  def process_one_game_tick
    raise RuntimeError, "systems must override process_one_game_tick()"
  end
end
