class Player
  attr_accessor :name, :score, :current_move, :move_history

  def initialize
    set_name
    @score = 0
    @current_move = nil
    @move_history = []
  end

  def increment_score
    self.score += 1
  end

  def reset
    self.score = 0
    self.move_history = []
    self.current_move = nil
  end

  def update_move_history(move)
    @move_history << move
  end

  def favorite_move(move_history)
    move_count = move_history.group_by { |move| move_history.count(move) }
    if move_history.size > 1
      return move_count[move_count.keys.max].first
    end

    nil
  end
end
