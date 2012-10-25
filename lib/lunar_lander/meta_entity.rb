##
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
# - A (possibly null) internal "name" that is easier for humans to read than the
#   UUID when debugging
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
class MetaEntity
  def initialize(entity_manager, name)
    @entity_manager = entity_manager
    @internal_name  = name
    @uuid           = @entity_manager.create_named_entity(name)
  end

  # def self.load_from_entity_manager(uuid)
  #   e = new Entity(uuid)
  #   return e    
  # end

  def add_component(component)
    @entity_manager.add_component(@uuid, component)  
  end

  def has_component(component_class)
    @entity_manager.has_component(@uuid, component)      
  end

  def get_component(component_class)
    @entity_manager.get_component(@uuid, component)  
  end

  def remove_component(component)
    @entity_manager.remove_component(@uuid, component)
  end

  def get_all_components
    @entity_manager.get_all_components_on_entity(@uuid)
  end

  def remove_all_components
    @components.each do |c|
      remove_component c.class
    end
  end

  def kill
    @entity_manager.kill_entity(@uuid)
  end

  def to_s
    "MetaEntity {#{@uuid} (#{@internal_name})}"
  end
end

