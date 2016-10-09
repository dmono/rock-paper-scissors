# frozen_string_literal: true

class Move
  VALUES = {
    "r" => "rock",
    "p" => "paper",
    "s" => "scissors",
    "v" => "Spock",
    "l" => "lizard"
  }.freeze

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def spock?
    @value == 'Spock'
  end

  def lizard?
    @value == 'lizard'
  end

  def >(other_move)
    (rock? && other_move.scissors?) ||
      (rock? && other_move.lizard?) ||
      (paper? && other_move.rock?) ||
      (paper? && other_move.spock?) ||
      (scissors? && other_move.paper?) ||
      (scissors? && other_move.lizard?) ||
      (spock? && other_move.scissors?) ||
      (spock? && other_move.rock?) ||
      (lizard? && other_move.paper?) ||
      (lizard? && other_move.spock?)
  end

  def <(other_move)
    (rock? && other_move.paper?) ||
      (rock? && other_move.spock?) ||
      (paper? && other_move.scissors?) ||
      (paper? && other_move.lizard?) ||
      (scissors? && other_move.rock?) ||
      (scissors? && other_move.spock?) ||
      (spock? && other_move.lizard?) ||
      (spock? && other_move.paper?) ||
      (lizard? && other_move.scissors?) ||
      (lizard? && other_move.rock?)
  end

  def to_s
    @value
  end
end

class Score
  attr_accessor :count

  def initialize
    @count = 0
  end

  def increment
    self.count += 1
  end

  def reset
    @count = 0
  end
  
  def to_s
    "#{count}"
  end
end

class Player
  attr_accessor :move, :name, :score, :move_history

  def initialize
    set_name
    @score = Score.new
    @move_history = []
  end
  
  def update_move_history(move)
    @move_history << move
  end
end

class Human < Player
  def set_name
    n = ""
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def display_choices
    choice_prompt = <<-MSG
      Choose a letter:
      R (rock)
      P (paper)
      S (scissors)
      V (Spock)
      L (lizard)
    MSG
    puts choice_prompt
  end

  def choose
    choice = nil
    loop do
      display_choices
      choice = gets.chomp.downcase
      break if Move::VALUES.keys.include? choice
      puts "Sorry, invalid choice."
    end
    choice_value = Move::VALUES[choice]
    update_move_history(choice_value)
    self.move = Move.new(choice_value)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie'].sample
  end
  
  def choice_probability
    default = 100 / Move::VALUES.values.size  
  end

  def choose
    choice = Move::VALUES.values.sample
    update_move_history(choice)
    self.move = Move.new(choice)
  end
end

# Game Orchestration Engine

class RPSGame
  WINNING_SCORE = 3

  attr_accessor :human, :computer
  attr_reader :exit_round

  def initialize
    @human = Human.new
    @computer = Computer.new
    @exit_round = false
  end

  def display_welcome_message
    puts "Hi #{human.name}! Welcome to Rock, Paper, Scissors, Spock, Lizard!"
    puts "The first player to reach #{WINNING_SCORE} points is the winner!"
    puts "Your opponent is #{computer.name}."
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Spock, Lizard. Good bye!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def round_winner
    if human.move > computer.move
      human.score.increment
      return human
    elsif computer.move > human.move
      computer.score.increment
      return computer
    end
  
    nil
  end

  def display_round_winner
    winner = round_winner
    
    if winner == human
      puts "#{human.name} won this round!"
    elsif winner == computer
      puts "#{computer.name} won this round!"
    else
      puts "It's a tie!"
    end
  
    display_score
  end

  def display_score
    puts "Score = #{human.name}: #{human.score} | #{computer.name}: #{computer.score}"
  end
  
  def game_winner?
    human.score.count == WINNING_SCORE || computer.score.count == WINNING_SCORE
  end

  def display_game_winner
    if human.score.count == WINNING_SCORE
      puts "Congratulations! #{human.name} has won the game!"
    elsif computer.score.count == WINNING_SCORE
      puts "Sorry, you lost! #{computer.name} is the winner of the game!"
    end
  end

  def display_move_history
    puts "#{human.name}'s moves: #{human.move_history}"
    puts "#{computer.name}'s moves: #{computer.move_history}"
  end

  def play_next_round?
    answer = nil

    loop do
      puts "Continue to the next round? (y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include? answer
      puts "Sorry, must be y or n."
    end

    @exit_round = true if answer == 'n'
    answer == 'y'
  end
  
  def play_another_game?
    answer = nil
    
    loop do
      puts "Play another game? (y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include? answer
      puts "Sorry, must be y or n."
    end
    
    answer == 'y'
  end
  
  def reset
    human.score.reset
    computer.score.reset
    computer.set_name
  end

  def play
    loop do
      display_welcome_message
      loop do
        human.choose
        computer.choose
        display_moves
        display_round_winner
        break if game_winner?
        break unless play_next_round?
      end
      break if @exit_round
      display_game_winner
      display_move_history
      break unless play_another_game?
      reset
    end
    display_goodbye_message
  end
end

RPSGame.new.play
