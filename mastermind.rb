# frozen_string_literal: true

# players class handles player input
class Players
  attr_accessor :secret_guess

  def initialize
    @secret_guess = ''
  end

  def enter_secret_guess
    puts 'enter a 4 digit code'
    @secret_guess = gets.chomp.to_i
  end
end
