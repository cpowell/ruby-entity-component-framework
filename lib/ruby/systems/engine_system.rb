class EngineSystem < System

  def process_one_game_tick(container, delta, entity_mgr)
    engine_entities = entity_mgr.get_all_entities_with_component_of_type(Engine)
    engine_entities.each do |entity|
      engine_component = entity_mgr.get_entity_component_of_type(entity, Engine)
      fuel_component   = entity_mgr.get_entity_component_of_type(entity, Fuel)

      if engine_component.on && fuel_component.remaining > 0
        location_component   = entity_mgr.get_entity_component_of_type(entity, SpatialState)
        renderable_component = entity_mgr.get_entity_component_of_type(entity, Renderable)

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
