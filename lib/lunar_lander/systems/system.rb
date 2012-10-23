class System
  attr_reader :name

  def process_one_game_tick
    raise RuntimeError, "systems must override process_one_game_tick()"
  end
end
