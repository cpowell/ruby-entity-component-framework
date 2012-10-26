class Physics < System
  # This constant could conceivably live in the gravity component...
  ACCELERATION = 0.005 # m/s^2
  DOWN = Math.cos(Math::PI)

  def process_one_game_tick(container, delta, entity_mgr)

    # MetaEntity way:
    # gravity_entity_ids = entity_mgr.get_all_entities_possessing_component_of_type(GravitySensitive)
    # gravity_entity_ids.each do |uuid|
    #   me = MetaEntity.load_from_entity_manager(uuid)

    #   spatial_component = me.get_entity_component_of_type(SpatialState)

    #   # move horizontally according to dx
    #   amount = 0.01 * delta * spatial_component.dx
    #   spatial_component.x += (amount)

    #   # vertical speed will feel gravity's effect
    #   spatial_component.dy += ACCELERATION * delta

    #   # now fall according to dy
    #   amount = -0.01 * delta * spatial_component.dy
    #   spatial_component.y += (amount * DOWN)
    # end

    gravity_entities = entity_mgr.get_all_entities_possessing_component_of_type(GravitySensitive)
    gravity_entities.each do |e|
      spatial_component = entity_mgr.get_entity_component_of_type(e, SpatialState)

      # move horizontally according to dx
      amount = 0.01 * delta * spatial_component.dx
      spatial_component.x += (amount)

      # vertical speed will feel gravity's effect
      spatial_component.dy += ACCELERATION * delta

      # now fall according to dy
      amount = -0.01 * delta * spatial_component.dy
      spatial_component.y += (amount * DOWN)
    end
  end
end
