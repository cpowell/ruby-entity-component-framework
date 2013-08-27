##
# Copyright 2012, Prylis Incorporated.
#
# This file is part of The Ruby Entity-Component Framework.
# https://github.com/cpowell/ruby-entity-component-framework
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

# A Entity in a game is an object that exists in the world defined by the game.
#
# This means that almost everything is a game entity, from the player character
# to the box that holds the score. Some entities may be visible, others may be mobile,
# but all of them are part of the world of the game (even if invisible).

class EntityManager
  attr_accessor :game
  attr_reader :id

  def initialize
    @id          = java.util.UUID.randomUUID().to_s
    @ids_to_tags = Hash.new
    @tags_to_ids = Hash.new

    @component_stores = Hash.new { |h, k| h[k] = {} }

    @mutex = Mutex.new
  end

  def all_entities
    return @ids_to_tags.keys
  end

  def create_basic_entity
    uuid = java.util.UUID.randomUUID().to_s
    @ids_to_tags[uuid]='-' # means "untagged" so it doesn't go into tags_to_ids
    return uuid
  end

  def create_tagged_entity(human_readable_tag)
    raise ArgumentError, "Must specify tag" if human_readable_tag.nil?
    raise ArgumentError, "Tag '-' is reserved and cannot be used" if human_readable_tag=='-'

    @mutex.synchronize do
      uuid=create_basic_entity
      @ids_to_tags[uuid]=human_readable_tag
      if @tags_to_ids.has_key? human_readable_tag
        @tags_to_ids[human_readable_tag]<<uuid
      else
        @tags_to_ids[human_readable_tag]=[uuid]
      end

      return uuid
    end
  end

  def get_all_entities_with_tag(tag)
    @tags_to_ids[tag]
  end

  # def set_tag(entity, human_readable_tag)
  #   raise ArgumentError, "UUID and tag must be specified" if entity.nil? || human_readable_tag.nil?

  #   @ids_to_tags[entity]=human_readable_tag
  #   @tags_to_ids[]
  #   @tags_to_ids[human_readable_tag]<<entity
  # end

  def get_tag(entity)
    raise ArgumentError, "UUID must be specified" if entity.nil?

    @ids_to_tags[entity]
  end

  def has_component?(entity, component)
    raise ArgumentError, "UUID and component must be specified" if entity.nil? || component.nil?

    store = @component_stores[component.class]
    if store.nil?
      return false # NOBODY has this component type
    else
      return store.has_key?(entity) && store[entity].include?(component)
    end
  end

  def has_component_of_type?(entity, component_class)
    raise ArgumentError, "UUID and component class must be specified" if entity.nil? || component_class.nil?

    store = @component_stores[component_class]
    if store.nil?
      return false # NOBODY has this component type
    else
      return store.has_key?(entity) && store[entity].size > 0
    end
  end


  def add_component(entity, component)
    raise ArgumentError, "UUID and component must be specified" if entity.nil? || component.nil?

    # Get the store for this component class.
    # If it doesn't exist, make it.
    store = @component_stores[component.class]
    @mutex.synchronize do
      if store.nil?
        store = Hash.new
        @component_stores[component.class]=store
      end

      if store.has_key? entity
        store[entity] << component unless store[entity].include? component
      else
        store[entity] = [component]
      end
    end
  end

  def add_singleton_component(entity, component)
    if has_component_of_type?(entity, component.class.to_s.to_sym)
      $logger.warn "Denied attempt to add more than one singleton #{component} to #{entity}"
      return false
    end

    add_component(entity, component)
  end

  def remove_component(entity, component)
    raise ArgumentError, "UUID and component must be specified" if entity.nil? || component.nil?

    Thread.exclusive do
      store = @component_stores[component.class]
      return nil if store.nil?

      components = store[entity]
      return nil if components.nil?

      result = components.delete(component)
      if result.nil?
        raise ArgumentError, "Entity #{entity} did not possess #{component} to remove"
      else
        store.delete(entity) if store[entity].empty?
        return true
      end
    end
  end

  def get_component_of_type(entity, component_class)
    raise ArgumentError, "UUID and component class must be specified" if entity.nil? || component_class.nil?

    # return nil unless has_component_of_type?(entity, component.class)
    store = @component_stores[component_class]
    return nil if store.nil?

    components = store[entity]
    return nil if components.nil? || components.empty?

    if components.size != 1
      puts "Warning: you probably expected #{entity} to have just one #{component_class.to_s} but it had #{components.size}...returning first."
    end

    return components.first
  end

  def get_components_of_type(entity, component_class)
    raise ArgumentError, "UUID and component class must be specified" if entity.nil? || component_class.nil?

    # return nil unless has_component_of_type?(entity, component.class)
    store = @component_stores[component_class]
    return nil if store.nil?

    components = store[entity]
    return nil if components.nil? || components.empty?

    return components
  end

  def get_all_components_of_type(component_sym)
    Set.new(@component_stores[component_sym].values).flatten
  end

  def get_all_components(entity)
    raise ArgumentError, "UUID must be specified" if entity.nil?

    @mutex.synchronize do
      components = []
      @component_stores.values.each do |store|
        if store[entity]
          components += store[entity]
        end
      end
      components
    end
  end

  def get_all_entities_with_component_of_type(component_class)
    raise ArgumentError, "Component class must be specified" if component_class.nil?

    store = @component_stores[component_class]
    if store.nil?
      return []
    else
      return store.keys
    end
  end

  def get_all_entities_with_components_of_type(component_classes)
    raise ArgumentError, "Component classes must be specified" if component_classes.nil?

    entities = all_entities
    component_classes.each do |klass|
      entities = entities & get_all_entities_with_component_of_type(klass)
    end
    return entities
  end

  def kill_entity(entity)
    raise ArgumentError, "UUID must be specified" if entity.nil?

    @component_stores.each_value do |store|
      store.delete(entity)
    end
    @tags_to_ids.each_key do |tag|
      if @tags_to_ids[tag].include? entity
        @tags_to_ids[tag].delete entity
      end
    end

    if @ids_to_tags.delete(entity)==nil
      return false
    else
      return true
    end
  end

  def dump_details
    output = to_s
    all_entities.each do |e|
      output << "\n #{e} (#{@ids_to_tags[e]})"
      comps = get_all_components(e)
      comps.each do |c|
        output << "\n   #{c.to_s}"
      end
    end

    output
  end

  def marshal_dump
    [@id, @ids_to_tags, @tags_to_ids, @component_stores]
  end

  def marshal_load(array)
    @id, @ids_to_tags, @tags_to_ids, @component_stores = array
  end

  def to_s
    "EntityManager {#{id}: #{all_entities.size} managed entities}"
  end
end
