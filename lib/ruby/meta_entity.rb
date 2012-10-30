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

# The MetaEntity is a smarter, more powerful way of creating and handling Entities
# in an Entity System.
#
# It takes a lot of the boilerplate code for creating, editing, and deleting
# entities, and packages it up in a neat OOP class that's easy to use, and easy to
# pass around from method to method, system to system.
#
# NB: it is LESS EFFICIENT than manually handling your Entities - it adds the
# overhead of:
# - An object-instance per entity
# - A reference to the EntityManager where the Entity lives (if you only have a
#   single EntityManager in your app, then this is just wasting memory)
# - A (possibly null, not unique) "tag" that helps identify the entity and 
#   is easier for humans to read than the UUID when debugging
#
# Usage suggestions: To avoid performance degradation, it's expected that you'll
# only use MetaEntity objects sparingly, and temporarily.
#
# When you have a system that isn't performance limited, you might write it to use
# MetaEntity objects, to increase readability.
#
# If you have performance problems, you can re-write critical sections directly
# using Entity's, removing the overhead of this class.
#
# http://t-machine.org/index.php/2011/08/22/entity-system-rdbms-beta-a-new-example-with-source
#
class MetaEntity
  @@default_entity_manager=nil

  attr_reader :uuid
  attr_reader :entity_manager
  attr_accessor :internal_name

  def self.default_entity_manager=(value)
    @@default_entity_manager = value
  end
  
  # def self.load_from_entity_manager(uuid)
  #   if @@default_entity_manager.nil?
  #     raise RuntimeError, "There is no global EntityManager; create a new EntityManager before creating MetaEntities"
  #   end
  #   e = new MetaEntity(uuid)
  # end

  # #protected
  # #This should NEVER be called by external classes - it's used by the static method loadFromEntityManager
  # def self.init_with_uuid(uuid)
  #   if @@default_entity_manager.nil?
  #     raise RuntimeError, "There is no global EntityManager; create a new EntityManager before creating MetaEntities"
  #   end
  #   @entity_manager = @@default_entity_manager 
  #   @uuid=uuid
  # end

  # Invoke this to use the global default {@link EntityManager} as the source
  # varargs = all the arguments that are bundled into a new Array
  # spec:
  # - zero arguments
  # - one argument: name
  def initialize(*varargs)
    if @@default_entity_manager.nil?
      raise RuntimeError, "There is no global EntityManager; create a new EntityManager before creating MetaEntities"
    end

    @entity_manager = @@default_entity_manager 
    
    case varargs.length
    when 0
      @uuid = @entity_manager.create_basic_entity
    when 1
      @uuid = @entity_manager.create_tagged_entity(varargs[0])
    end
  end

  # # This is the main constructor for Entities - usually, you'll know which Components you want them to have
  # # 
  # # NB: this is a NON-lazy way of instantiating Entities - in low-mem situations, you may want to
  # # use an alternative constructor that accepts the CLASS of each Component, rather than the OBJECT, and
  # # which only instantiates / allocates the memory for the data of each component when that component is
  # # (eventually) initialized.
  # # 
  # # @param n the internal name that will be attached to this entity, and reported in debugging info
  # # @param components
  # def self.init_with_tag_and_components(name, components)
  #   me = MetaEntity.new(name)
  #   me.internal_name=name
  #   me.add_all_components(components)
  #   me
  # end

  # # This is the main constructor for Entities - usually, you'll know which Components you want them to have
  # # 
  # # NB: this is a NON-lazy way of instantiating Entities - in low-mem situations, you may want to
  # # use an alternative constructor that accepts the CLASS of each Component, rather than the OBJECT, and
  # # which only instantiates / allocates the memory for the data of each component when that component is
  # # (eventually) initialized.
  # #
  # # @param components
  # def self.init_with_components(components)
  #   me = MetaEntity.new
  #   me.add_all_components(components)
  #   me
  # end

  # def initialize(entity_manager, name, components)
  #   @entity_manager = entity_manager
  #   @internal_name  = name
  #   @uuid           = @entity_manager.create_tagged_entity(name)
  # end

  def add_component(component)
    @entity_manager.add_entity_component(@uuid, component)  
  end

  def add_all_components(components)
    components.each do |component|
      @entity_manager.add_entity_component(@uuid, component)  
    end
  end

  def has_component(component_class)
    @entity_manager.entity_has_component(@uuid, component)      
  end

  def get_component(component_class)
    @entity_manager.get_entity_component_of_type(@uuid, component_class)  
  end

  def remove_component(component)
    @entity_manager.remove_entity_component(@uuid, component)
  end

  def get_all_components
    @entity_manager.get_all_components_on_entity(@uuid)
  end

  def remove_all_components
    @components.each do |c|
      remove_entity_component c.class
    end
  end

  def kill
    @entity_manager.kill_entity(@uuid)
  end

  def to_s
    "MetaEntity {#{@uuid} (#{@internal_name})}"
  end
end

