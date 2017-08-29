require_relative 'player'

class Human < Player
  def set_name
    n = ""
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.strip.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def display_choices(moves)
    puts "-" * 50
    puts "Choose a letter:"
    moves.each { |option| puts "  #{option.initial} (#{option.value})" }
  end

  def choose(moves)
    choice = nil
    loop do
      display_choices(moves)
      choice = gets.chomp.upcase
      break if moves.map(&:initial).include? choice
      puts "Sorry, invalid choice."
    end

    self.current_move = moves.detect { |move| move.initial == choice }
    update_move_history(current_move)
  end
end
