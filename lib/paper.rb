require_relative 'move'

class Paper < Move
  def initialize
    @value = 'paper'
    @initial = 'P'
  end

  def beats?(other_move)
    other_move.value == 'rock' || other_move.value == 'Spock'
  end
end
