require_relative 'computer'

class R2D2 < Computer
  # Likes to throw Rock and Scissors. Hates Spock.

  def choose(moves)
    odds = rand(100)

    move_options = {
      "rock" => (0..35),
      "paper" => (36..50),
      "scissors" => (51..85),
      "Spock" => (86..90),
      "lizard" => (91..100)
    }

    weighted_key = move_options.select { |_, v| v.include?(odds) }.keys.first
    self.current_move = moves.select { |move| move.value == weighted_key }.first
    update_move_history(current_move)
  end
end
