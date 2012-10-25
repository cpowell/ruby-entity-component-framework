require 'systems/system'
require 'spatial_state'

class SpatialSystem < System
  def process_one_game_tick(container, delta, entity_mgr)
  end

  def get_x_position(entity)
    spatial_component = @game.entity_manager.get_component(entity, SpatialState)
    return spatial_component.x
  end

  def alter_x_position(entity, amount)
    spatial_component = @game.entity_manager.get_component(entity, SpatialState)
    spatial_component.x+=amount
  end

  def get_y_position(entity)
    spatial_component = @game.entity_manager.get_component(entity, SpatialState)
    return spatial_component.y
  end

  def alter_y_position(entity, amount)
    spatial_component = @game.entity_manager.get_component(entity, SpatialState)
    spatial_component.y+=amount
  end

end
