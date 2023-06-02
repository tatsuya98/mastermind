# rubocop:disable Naming/PredicateName
# frozen_string_literal: true

require 'pry-byebug'

# players class handles player input
class Player
  attr_accessor :secret_guess, :red_pegs, :white_pegs

  def initialize
    @secret_guess = ''
  end

  def enter_secret_guess
    puts 'enter a 4 digit guess'
    @secret_guess = gets.chomp
  end
end

# Computer class
class Computer < Player
  attr_accessor :list_of_possible_answers, :computer_answer

  def initialize
    super
    @list_of_possible_answers = []
    @computer_answer = ''
    @possible_answers = []
  end

  def create_code
    @secret_guess = 4.times.map { '123456'.chars.sample }.join
  end

  def create_all_possible_answers
    possible_colours = %w[1 2 3 4 5 6]
    @possible_answers  = possible_colours.repeated_permutation(4).to_a
  end
end

# Game class handles gameplay
class Game
  attr_accessor :count

  def initialize
    @player1 = Player.new
    @player2 = Computer.new
    @board = Board.new
  end

  def play_game
    count = 1
    @player2.computer_answer = @player2.create_code
    12.times do
      @player1.enter_secret_guess
      @board.give_feedback(@player1.secret_guess, @player2.computer_answer)
      @board.current_state(@player1.secret_guess, count)
      if @board.pegs == 'BBBB'
        @board.display_answer_guess_count(@player1.secret_guess, count)
        break
      end
      count += 1
    end
    return unless count == 12

    puts "you have failed to guess the other player's code: #{@player2.computer_answer}"
  end
end

# Board class displays current and final count and guess
class Board
  attr_accessor :pegs

  def initialize
    @pegs = ''
  end

  def give_feedback(guess, answer)
    answer = answer.dup.chars
    guess = guess.dup.chars
    @pegs = @pegs.dup
    count = 0
    @pegs.clear
    4.times do
      if duplicate?(guess, answer, count)
        puts "trigger at #{count}"
        guess[count] = '0'
        puts guess
      elsif equal?(guess, answer, count)
        @pegs << 'B'
      elsif different?(guess, answer, count)
        @pegs << 'W'
      end
      count += 1
      next
    end
    puts @pegs if @pegs != ''
  end

  def display_answer_guess_count(secret_guess, count)
    puts "#{secret_guess} guessed in #{count} rounds"
  end

  def equal?(guess, answer, count)
    guess[count] == answer[count]
  end

  def different?(guess, answer, count)
    guess[count] != answer[count] && answer.include?(guess[count])
  end

  def duplicate?(guess, answer, count)
    guess.count { |code_peg| code_peg == answer[count] } > answer.count { |code_peg| code_peg == answer[count] }
  end

  def current_state(secret_guess, count)
    puts "round #{count} : guess : #{secret_guess}"
  end
end

game = Game.new
game.play_game

# rubocop:enable Naming/PredicateName
