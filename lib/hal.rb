require_relative 'computer'

class Hal < Computer
  # Never throws the same move twice in a row.

  def choose(moves)
    selected_move = nil
    loop do
      selected_move = moves.sample
      break if selected_move != move_history.last
    end

    self.current_move = selected_move
    update_move_history(current_move)
  end
end
