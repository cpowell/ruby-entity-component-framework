class EngineSystem < System

  def process_one_game_tick(container, delta, entity_mgr)
  end

  def fire_engine(delta, entity_mgr, entity)
    location_component   = entity_mgr.get_component(entity, SpatialState)
    renderable_component = entity_mgr.get_component(entity, Renderable)
    engine_component     = entity_mgr.get_component(entity, Engine)

    current_rotation   = renderable_component.rotation

    x_vector =  (engine_component.thrust*delta) * Math.sin(current_rotation * Math::PI / 180.0);
    y_vector = -(engine_component.thrust*delta) * Math.cos(current_rotation * Math::PI / 180.0);

    location_component.dy += y_vector
    location_component.dx += x_vector

    #if (@fuel > 0)
    #  @fuel -= THRUST*delta
    #  @fuel = 0 if @fuel < 0
    #end
  end
end
