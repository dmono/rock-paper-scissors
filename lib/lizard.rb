require_relative 'move'

class Lizard < Move
  def initialize
    @value = 'lizard'
    @initial = 'L'
  end

  def beats?(other_move)
    other_move.value == 'paper' || other_move.value == 'Spock'
  end
end
