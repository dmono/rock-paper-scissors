require_relative 'move'

class Spock < Move
  def initialize
    @value = 'Spock'
    @initial = 'V'
  end

  def beats?(other_move)
    other_move.value == 'scissors' || other_move.value == 'rock'
  end
end
