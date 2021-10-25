class Mastermind

  def welcome
    puts "Would you want to play a mastermind game? Type 'Y' to play."
    answer=gets.gsub("\n","")
    answer=="Y" ? game : bye_message
  end

  def bye_message
    p "Maybe later then,bye."
  end

  def game
    info_message
    round=0
    code=Array.new
    is_guess_true=false
    4.times do
      digit=rand(7)
      code.push(digit)
    end
    p code
    while round<12 && is_guess_true!=true do
      is_guess_true=play_round(code,round)
      round+=1
    end
    is_guess_true==true ? victory_message : defeat_message
  end

  def info_message
    p "Hi, player. You must guess the code made of four digits using the minimum number of digits."
  end

  def play_round(code,round)
    clues=""
    puts "\nPlease make a guess of four digits."
    guess_string=gets.gsub("\n","")
    guess=guess_string.split("")
    number_of_full_circles=0
    number_of_empty_circles=0
    code.each_with_index do |code_digit,code_index|
      guess.each_with_index do |guess_digit,guess_index|
        full_circles=0
        empty_circles=0
        guess_digit = guess_digit.to_i
        if code_digit == guess_digit && guess_index == code_index
          full_circles += 1
        elsif code_digit == guess_digit
          empty_circles += 1
        end
        if full_circles == 1
          number_of_full_circles += 1
        elsif empty_circles == 1
          number_of_empty_circles += 1
        end
      end
    end
    number_of_full_circles.times do
      clues+=("● ") 
    end
    number_of_empty_circles.times do
      clues+=("○ ")
    end
    number_of_full_circles==4 ? true : make_game_space(guess_string,clues,round)
  end

  def make_game_space(guess_string,clues,round)
    p "Round:#{round}  Guess: "+guess_string+"  Clues: "+clues
  end
  
  def defeat_message
    p "You lost"
  end

  def victory_message
    p "You won"
  end

end

game=Mastermind.new
game.welcome