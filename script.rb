class Mastermind

  class Code
    attr_accessor :current_value
    attr_reader :backup_value

    def initialize(random)
      @current_value = random.dup
      @backup_value = random.dup
    end
  end

  def random_code
    code = []
    4.times do
      digit = rand(6)+1
      code.push(digit)
    end
    code
  end

  def welcome
    puts "Would you want to play a mastermind game? Type 'Y' to play."
    answer = gets.gsub("\n", '')
    answer == 'Y' ? game : bye_message
  end

  def bye_message
    p 'Maybe later then, bye.'
  end

  def end_of_game(is_guess_true, code)
    is_guess_true ? victory_message(code) : defeat_message(code)
  end

  def info_message
    p 'Hi, player. You must guess the code made of four digits using the minimum number of digits.'
  end

  def ask_for_guess
    puts "\nPlease make a guess of four digits."
    gets.gsub("\n", '').split('')
  end

  def valid_guess
    is_guess_valid = false
    until is_guess_valid
      guess = ask_for_guess
      guess.length == 4 ? is_guess_valid = true : (puts 'The guess you made is not valid.')
    end
    guess
  end

  def make_clues(guess, code)
    clues = String.new
    full_circles(guess, code).times do
      clues += '● '
    end
    empty_circles(guess, code).times do
      clues += '○ '
    end
    clues
  end

  def full_circles(guess, code)
    number_of_full_circles = 0
    guess.each_with_index do |guess_digit, guess_index|
      code.each_with_index do |code_digit, code_index|
        if code_digit == guess_digit.to_i && guess_index == code_index
          code[code_index] = '*'
          number_of_full_circles += 1
        end
      end
    end
    number_of_full_circles
  end

  def empty_circles(guess, code)
    number_of_empty_circles = 0
    guess.each do |guess_digit|
      code.each_with_index do |code_digit, code_index|
        if code_digit == guess_digit.to_i && code[code_index] != '*'
          code[code_index] = '*'
          number_of_empty_circles += 1
        end
      end
    end
    number_of_empty_circles
  end

  def play_round(code, round)
    guess = valid_guess
    clues = make_clues(guess, code)
    make_game_space(guess.join, clues, round)
    clues == '● ● ● ● '
  end

  def game
    code = Code.new(random_code)
    info_message
    round = 0
    result = false
    while round < 12 && !result
      round += 1
      result = play_round(code.current_value, round)
      code.current_value = code.backup_value.dup
    end
    end_of_game(result, code.backup_value)
  end

  def make_game_space(guess, clues, round)
    p "Round:#{round}  Guess: #{guess}  Clues: #{clues}"
  end

  def defeat_message(code)
    p "You lost. The code was #{code.join}"
  end

  def victory_message(code)
    p "You won. The code was #{code.join}"
  end
end

game = Mastermind.new
game.welcome
