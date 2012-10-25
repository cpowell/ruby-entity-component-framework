class EngineSystem < System

  def process_one_game_tick(container, delta, entity_mgr)
    engine_entities = entity_mgr.get_all_entities_possessing_component(Engine)
    engine_entities.each do |entity|
      engine_component = entity_mgr.get_component(entity, Engine)
      fuel_component   = entity_mgr.get_component(entity, Fuel)

      if engine_component.on && fuel_component.remaining > 0
        location_component   = entity_mgr.get_component(entity, SpatialState)
        renderable_component = entity_mgr.get_component(entity, Renderable)

        amount = engine_component.thrust*delta
        fuel_component.burn(amount)
        current_rotation   = renderable_component.rotation

        x_vector =  amount * Math.sin(current_rotation * Math::PI / 180.0);
        y_vector = -amount * Math.cos(current_rotation * Math::PI / 180.0);

        location_component.dy += y_vector
        location_component.dx += x_vector

        engine_component.on=false
      end
    end
  end
end
