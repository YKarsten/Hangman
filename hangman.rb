txt = File.read('google-10000-english-no-swears.txt').split("\n")

# Methods
def repeat(n)
  print '_ ' * n
  puts "\n\n"
end

def secret(string)
  secret_words = Array.new(0)

  string.each_with_index do |word, index|
    if word.length>4 && word.length < 13
      secret_words[index] = word
    end
  end
  secret_words.reject! { |c| c.nil? || c&.empty? }
  secret_words.sample.split('').join(' ')
end

def make_guess(secret_word, user_in)
  reg_exp = "[^\s #{user_in}]"

  return secret_word.gsub(/#{reg_exp}/, '_')

  if secret_word.include?(user_in)
  else
    puts "\n#{user_in} is not in the secret word."
  end
end

def game_lost(secret_word)
  puts "You used up all your tries.
  The correct word was #{secret_word}"
end

def game_won(count)
  puts "\nCongrats you won this game of hangman!
  It only took you #{count} tries to get to the secret word."
end

# Variables
secret_word = secret(txt)
wrong_guess= " " # Keeping count of wrong inputs doesnt work yet
count = 0
player_guesses = ''

# Game set up
puts "The game starts. blablabla \n\n"
puts secret_word
repeat(secret_word.length)

# Game flow
while count <= 10 # not ideal

  # User input
  puts "\nHangman. Make a guess"
  user_in = gets.chomp.downcase

  unless user_in.length == 1
    puts 'Only enter a single letter'
    user_in = gets.chomp
  end
  player_guesses << user_in

  attempt = make_guess(secret_word, player_guesses)
  puts attempt

  count += 1

  # Won
  if count == 11
    game_lost(secret_word)
    break
  end

  # Lost
  if attempt.include?('_') == false
    game_won(count)
    break
  end

end
