require_relative 'move'

class Scissors < Move
  def initialize
    @value = 'scissors'
    @initial = 'S'
  end

  def beats?(other_move)
    other_move.value == 'paper' || other_move.value == 'lizard'
  end
end
