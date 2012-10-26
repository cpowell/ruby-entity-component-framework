# FIXME this whole thing needs to be refactored to permit an Entity to have more than
# one Component of a certain type. Right now it's flawed because an Entity only gets one
# Gun, MissileLauncher, whatever.

require 'SecureRandom'

# A Entity in a game is an object that exists in the world defined by the game.
#
# This means that almost everything is a game entity, from the player character 
# to the box that holds the score. Some entities may be visible, others may be mobile, 
# but all of them are part of the world of the game (even if invisible).
class EntityManager
  attr_reader :game

  def initialize(game)
    @game     = game
    @entities = []
    @entity_names = Hash.new

    # "Stores" hash: key=component class, value=a component store
    # Each "component store" hash: key=entity UUID, value=an array of components
    @component_stores = Hash.new
  end

  def create_basic_entity
    uuid = SecureRandom.uuid
    @entities << uuid
    return uuid
  end

  def create_named_entity(human_readable_name)
    uuid=create_basic_entity
    @entity_names[uuid]=human_readable_name    
    return uuid
  end

  def set_entity_name(entity_uuid, human_readable_name)
    @entity_names[entity_uuid]=human_readable_name
  end

  def get_entity_name(entity_uuid)
    @entity_names[entity_uuid]
  end

  def kill_entity(entity_uuid)
    @component_stores.each_value do |store|
      store.delete(entity_uuid)
    end
    @entities.delete(entity_uuid)
  end

  # Pretty much exists just for the unit tests:
  def get_known_entities
    @entities
  end

  #TODO a method to get all entities matching a basket of components

  def add_entity_component(entity_uuid, component)
    # Get the store for this component class.
    # If it doesn't exist, make it.
    store = @component_stores[component.class]
    if store.nil?
      store = Hash.new
      @component_stores[component.class]=store
    end

    if store.has_key? entity_uuid
      store[entity_uuid] << component
    else
      store[entity_uuid] = [component]
    end
  end

  def entity_has_component(entity_uuid, component)
    store = @component_stores[component.class]
    if store.nil?
      # NOBODY has this component type
      return false
    else
      return store.has_key?(entity_uuid) && store[entity_uuid].include?(component)
    end
  end

  def entity_has_component_of_type(entity_uuid, component_class)
    store = @component_stores[component_class]
    if store.nil?
      # NOBODY has this component type
      return false
    else
      return store.has_key? entity_uuid
    end
  end

  def get_entity_component_of_type(entity_uuid, component_class)
    # return nil unless entity_has_component_of_type(entity_uuid, component.class)
    store = @component_stores[component_class]
    return nil if store.nil?

    components = store[entity_uuid]
    return nil if components.nil?

    if components.size > 1
      puts "Warning: you probably expected #{entity_uuid} to have just one #{component_class.to_s} but it had #{components.size}...returning first."
    end

    return components.first
  end

  def remove_entity_component(entity_uuid, component)
    store = @component_stores[component.class]
    return nil if store.nil?

    components = store[entity_uuid]
    return nil if components.nil?

    result = components.delete(component)
    if result.nil?
      raise ArgumentError, "Entity #{entity_uuid} did not possess #{component} to remove"
    else
      return true
    end
  end

  def get_all_components_on_entity(entity_uuid)
    components = []
    @component_stores.values.each do |store|
      if store[entity_uuid]
        components += store[entity_uuid]
      end
    end
    components
  end

  # def get_all_components_on_entity_of_type(entity, component_class)
  #   store = @component_stores[component_class]
  #   if store.nil?
  #     return []
  #   else
  #     store.values.each 
  #   end
  # end

  # def get_all_components_of_type(component_class)
  #   store = @component_stores[component_class]
  #   if store.nil?
  #     return []
  #   else
  #     return store.values
  #   end
  # end

  def get_all_entities_possessing_component_of_type(component_class)
    store = @component_stores[component_class]
    if store.nil?
      return []
    else
      return store.keys
    end
  end

  def dump_to_screen
    @entities.each do |e|
      puts "#{e} (#{@entity_names[e]})"
      comps = get_all_components_on_entity(e)
      comps.each do |c|
        puts "  #{c.to_s}"
      end
    end
  end

  def to_s
    "EntityManager {#{id}}"
  end

  #===============================================
  private


end
