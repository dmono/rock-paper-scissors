# frozen_string_literal: true

require './lib/chappie'
require './lib/hal'
require './lib/r2d2'
require './lib/human'
require './lib/rock'
require './lib/paper'
require './lib/scissors'
require './lib/spock'
require './lib/lizard'

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
