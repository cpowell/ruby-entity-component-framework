class System
  attr_reader :name

  # id is the name of the method called, the * syntax collects
  # all the arguments in an array named 'arguments'
  def method_missing( id, *arguments )
    puts "Method #{id} was called, but not found. It has these arguments: #{arguments.join(", ")}"
  end

  def process_one_game_tick
    raise RuntimeError, "systems must override process_one_game_tick()"
  end
end
