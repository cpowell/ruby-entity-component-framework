class AsteroidSystem < System
  def process_one_game_tick(container, delta, entity_mgr)
    generate_new_asteroids(container, delta, entity_mgr)
    cleanup_asteroids(container, delta, entity_mgr)
  end

  def generate_new_asteroids(container, delta, entity_mgr)
    if rand(50)==0
      starting_x = -100
      starting_y = rand(300) - 150
      starting_dx = rand(15) + 2
      starting_dy = rand(20) - 10
      asteroid = entity_mgr.create_named_entity('asteroid')
      entity_mgr.add_entity_component asteroid, SpatialState.new(starting_x, starting_y, starting_dx, starting_dy)
      entity_mgr.add_entity_component asteroid, Renderable.new(RELATIVE_ROOT + "res/asteroid.png", 1.0, 0)
      entity_mgr.add_entity_component asteroid, PolygonCollidable.new
      entity_mgr.add_entity_component asteroid, Motion.new
    end      
  end

  def cleanup_asteroids(container, delta, entity_mgr)
    asteroid_entities = entity_mgr.get_all_entities_with_name('asteroid') || []

    asteroid_entities.each do |a|
      spatial_component = entity_mgr.get_entity_component_of_type(a, SpatialState)
      if spatial_component.x > container.width
        entity_mgr.kill_entity(a)
      end
    end
  end

end

