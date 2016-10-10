# frozen_string_literal: true

class Move
  attr_reader :value, :initial
end

class Rock < Move
  def initialize
    @value = 'rock'
    @initial = 'R'
  end

  def beats?(other_move)
    other_move.value == 'scissors' || other_move.value == 'lizard'
  end
end

class Paper < Move
  def initialize
    @value = 'paper'
    @initial = 'P'
  end

  def beats?(other_move)
    other_move.value == 'rock' || other_move.value == 'Spock'
  end
end

class Scissors < Move
  def initialize
    @value = 'scissors'
    @initial = 'S'
  end

  def beats?(other_move)
    other_move.value == 'paper' || other_move.value == 'lizard'
  end
end

class Lizard < Move
  def initialize
    @value = 'lizard'
    @initial = 'L'
  end

  def beats?(other_move)
    other_move.value == 'paper' || other_move.value == 'Spock'
  end
end

class Spock < Move
  def initialize
    @value = 'Spock'
    @initial = 'V'
  end

  def beats?(other_move)
    other_move.value == 'scissors' || other_move.value == 'rock'
  end
end

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

class Computer < Player
  def set_name
    self.name = self.class.name
  end
end

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

# Game Orchestration Engine

class RPSGame
  WINNING_SCORE = 10

  attr_accessor :human, :computer
  attr_reader :exit_round, :moves, :next_round

  def initialize
    @moves = [Rock.new, Paper.new, Scissors.new, Lizard.new, Spock.new]
    @human = Human.new
    @computer = nil
    @next_round = false
  end

  def play
    loop do
      display_welcome_message
      choose_computer
      loop do
        select_moves(moves)
        update_scores
        display_round_info
        @next_round = play_next_round?
        break if game_winner? || !next_round
      end
      break unless next_round
      display_game_winner
      display_move_history
      break unless play_another_game?
      reset
    end
    display_goodbye_message
  end

  private

  def display_welcome_message
    puts "Hi #{human.name}! Welcome to Rock, Paper, Scissors, Lizard, Spock!"
    puts "The first player to reach #{WINNING_SCORE} points is the winner!"
  end

  def assign_computer(choice)
    case choice
    when 'r'
      self.computer = R2D2.new
    when 'c'
      self.computer = Chappie.new
    when 'h'
      self.computer = Hal.new
    end
  end

  def choose_computer
    choice = ""
    puts ""
    puts "Select your opponent: (R)2D2, (C)happie, or (H)al"
    loop do
      choice = gets.chomp.downcase
      break if %w(r c h).include? choice
      puts "Sorry, that's not a valid answer. Please choose R, C or H."
    end

    assign_computer(choice)

    puts "Great! #{computer.name} is ready to battle!"
  end

  def select_moves(moves)
    human.choose(moves)

    if computer.name == "Chappie"
      computer.choose(moves, human.move_history)
    else
      computer.choose(moves)
    end
  end

  def round_winner
    if human.current_move.beats?(computer.current_move)
      return human
    elsif computer.current_move.beats?(human.current_move)
      return computer
    end

    nil
  end

  def update_scores
    winner = round_winner
    human.increment_score if winner == human
    computer.increment_score if winner == computer
  end

  def round_winner_output
    winner = round_winner
    if winner == human
      "#{human.name} won this round!"
    elsif winner == computer
      "#{computer.name} won this round!"
    else
      "It's a tie!"
    end
  end

  def score_output
    "Score = #{human.name}: #{human.score} | #{computer.name}: #{computer.score}"
  end

  def display_round_info
    puts "\nROUND RESULTS:"
    puts "#{human.name} chose #{human.current_move.value}."
    puts "#{computer.name} chose #{computer.current_move.value}."
    puts round_winner_output
    puts score_output
    puts ""
  end

  def game_winner?
    human.score == WINNING_SCORE || computer.score == WINNING_SCORE
  end

  def display_game_winner
    if human.score == WINNING_SCORE
      puts "Congratulations #{human.name}! You won the game!"
    elsif computer.score == WINNING_SCORE
      puts "Sorry, you lost! #{computer.name} is the winner of the game!"
    end
  end

  def display_move_history
    puts "\nPLAYER MOVE HISTORY:"
    puts "#{human.name}: #{human.move_history.map(&:value).join(', ')}"
    puts ""
    puts "#{computer.name}: #{computer.move_history.map(&:value).join(', ')}"
    puts ""
  end

  def play_next_round?
    answer = nil

    loop do
      puts "Continue to the next round? (y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include? answer
      puts "Sorry, must be y or n."
    end

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
    human.reset
    computer.reset
    computer.set_name
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock. Good bye!"
  end
end

RPSGame.new.play
