require_relative 'computer'

class Chappie < Computer
  # Always tries to beat an opponent's favorite move.

  def choose(moves, other_history)
    fav_move = favorite_move(other_history)
    self.current_move = if fav_move
                          moves.detect { |move| move.beats?(fav_move) }
                        else
                          moves.sample
                        end

    update_move_history(current_move)
  end
end
