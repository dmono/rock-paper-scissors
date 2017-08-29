require_relative 'move'

class Rock < Move
  def initialize
    @value = 'rock'
    @initial = 'R'
  end

  def beats?(other_move)
    other_move.value == 'scissors' || other_move.value == 'lizard'
  end
end
