##
# Copyright 2012, Prylis Incorporated.
#
# This file is part of The Ruby Entity-Component Framework.
# https://github.com/cpowell/ruby-entity-component-framework
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

class Component
  attr_reader :id

  def initialize
    @id = java.util.UUID.randomUUID().to_s  
  end

  def to_s
    "Component {#{id}: #{self.class.name}}"
  end
end
