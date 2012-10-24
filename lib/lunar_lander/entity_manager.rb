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

    # Hash of hashes. 
    # Stores hash: key=component class, value=a component store
    # Component store hash: key=entity UUID, value=a component
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

  def set_entity_name(uuid, human_readable_name)
    @entity_names[uuid]=human_readable_name
  end

  def get_entity_name(uuid)
    @entity_names[uuid]
  end

  def kill_entity(uuid)
    @component_stores.each_value do |store|
      store.delete(uuid)
    end
    @entities.delete(uuid)
  end

  def get_known_entities
    @entities
  end

  def add_component(uuid, component)
    store = @component_stores[component.class]
    if store.nil?
      store = Hash.new
      @component_stores[component.class]=store
    end
    store[uuid]=component
  end

  def has_component(uuid, component_class)
    store = @component_stores[component_class]
    if store.nil?
      return false
    else
      return store.has_key? uuid
    end
  end

  def get_component(uuid, component_class)
    store = @component_stores[component_class]
    if store.nil?
      raise ArgumentError, "There are no entities with a component of class #{component_class}"
    end

    result = store[uuid]
    if result.nil?
      raise ArgumentError, "Entity #{uuid} does not possess Component of #{component_class}"
    end

    return result
    #    @components.detect {|comp| comp.id==id}
  end

  def remove_component(uuid, component_class)
    store = @component_stores[component_class]
    if store.nil?
      raise ArgumentError, "There are no entities with a component of class #{component_class}"
    end

    comp = store[uuid]
    if comp.nil?
      raise ArgumentError, "Entity #{uuid} does not possess Component of #{component_class}"
    end

    result = store.delete(uuid)
    if result.nil?
      raise ArgumentError, "Entity #{uuid} did not possess Component #{component} to remove"
    end
  end

  def get_all_components_on_entity(uuid)
    components = []
    @component_stores.values.each do |store|
      if store[uuid]
        components << store[uuid]
      end
    end
    components
  end

  def get_all_components_of_type(component_class)
    store = @component_stores[component_class]
    if store.nil?
      return []
    else
      return store.values
    end
  end

  def get_all_entities_possessing_component(component_class)
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
end
