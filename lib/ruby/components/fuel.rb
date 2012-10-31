##
# Copyright 2012, Prylis Incorporated.
#
# This file is part of The Ruby Entity-Component Framework.
# https://github.com/cpowell/ruby-entity-component-framework
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

require 'components/component'

class Fuel < Component
  attr_accessor :remaining

  def initialize(remaining)
    super()
    @remaining=remaining
  end

  def burn(qty)
    @remaining -= qty
    @remaining = 0 if @remaining < 0
  end
end
