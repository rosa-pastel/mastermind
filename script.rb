module Messages
  def info_message
    puts 'Hi, player. You must guess the code made of four digits using the minimum number of digits.'
    puts 'Would you want to be the code maker or the code breaker?'
  end

  def defeat_message(code)
    p "You lost. The code was #{code.join}"
  end

  def victory_message(code)
    p "You won. The code was #{code.join}"
  end

  def bye_message
    puts 'Maybe later then, bye.'
  end
end

class Mastermind
  include Messages

  def self.all_possible_codes
    candidate_codes = [%w[1 1 2 2]]
    (1..6).each do |digit1|
      (1..6).each do |digit2|
        (1..6).each do |digit3|
          (1..6).each do |digit4|
            candidate_codes.push(%W[#{digit1} #{digit2} #{digit3} #{digit4}])
          end
        end
      end
    end
    candidate_codes
  end

  def welcome
    puts "Would you want to play a mastermind game? Type 'Y' to play."
    answer = gets.gsub("\n", '')
    answer == 'Y' ? pick_player : bye_message
  end

  def pick_player
    valid = false
    info_message
    until valid
      puts "Type 'M' to be code maker and 'B' to be code breaker."
      case gets.gsub("\n", '')
      when 'M'
        valid = true
        guesser = Guesser.new('computer')
        @candidate_codes = Mastermind.all_possible_codes
      when 'B'
        valid = true
        guesser = Guesser.new('human')
      end
    end
    game(guesser)
  end

  def play_round(code, round, guess_object)
    guess_object.clues = make_clues(guess_object.guess, code)
    make_game_space(guess_object.guess.join, guess_object.clues, round)
    guess_object.clues
  end

  def make_game_space(guess, clues, round)
    p "Round:#{round}  Guess: #{guess}  Clues: #{clues}"
  end

  def game(guesser)
    code = assign_code(guesser)
    round = 0
    result = false
    while round < 12 && !result
      round += 1
      clues = play_round(code.current_value, round, make_guess(guesser))
      result = clues == '● ● ● ● '
      code.current_value = code.backup_value.dup
    end
    end_of_game(result, code.backup_value)
  end

  def assign_code(guesser)
    if guesser.species == 'human'
      Code.new
    else
      puts 'Please type the four-digit code.'
      Code.new(gets.gsub("\n", '').split(''))
    end
  end

  def make_guess(guesser)
    valid = false
    until valid
      guess_object = guesser.species == 'human' ? human_guesses : computer_guesses
      guess_object.guess.length == 4 ? valid = true : (puts 'The guess you made is not valid.')
    end
    guess_object
  end

  def human_guesses
    puts "\nPlease make a guess of four digits."
    Guess.new(gets.gsub("\n", '').split(''), '')
  end

  def computer_guesses
    p @candidate_codes.length
    Guess.new(@candidate_codes[0])
  end

  def end_of_game(is_guess_true, code)
    is_guess_true ? victory_message(code) : defeat_message(code)
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
        if code_digit.to_i == guess_digit.to_i && guess_index == code_index
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

  

end

class Code
  attr_accessor :current_value
  attr_reader :backup_value

  def initialize(code = random_code)
    @current_value = code.dup
    @backup_value = code.dup
  end

  def random_code
    code = []
    4.times do
      digit = rand(1..6)
      code.push(digit)
    end
    code
  end
end

class Guesser
  attr_accessor :species

  def initialize(species)
    @species = species
  end


end

class Guess
  attr_accessor :guess, :clues

  def initialize(guess, clues = '')
    @guess = guess
    @clues = clues
  end
end

game = Mastermind.new
game.welcome
