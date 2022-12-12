# frozen_string_literal: true

require 'yaml'

# A console based game of Hangman in which the user needs to input single letters to guess a randomly chosen word
class Hangman
  attr_accessor :secret_word, :count, :player_guesses, :wrong_guess

  def initialize
    @txt = File.read('google-10000-english-no-swears.txt').split("\n")
    @secret_word = secret(@txt)
    @wrong_guess = ''
    @player_guesses = ''
    @count = 0
  end

  # Methods
  def secret(string)
    secret_words = Array.new(0)

    string.each_with_index do |word, index|
      secret_words[index] = word if word.length > 4 && word.length < 13
    end
    secret_words.reject! { |c| c.nil? || c&.empty? }
    secret_words.sample
  end

  def repeat(word_length)
    print '_ ' * word_length
    puts "\n\n"
  end

  def make_guess(secret_word, user_in)
    reg_exp = "[^\s #{user_in}]"

    return secret_word.gsub(/#{reg_exp}/, '_').split('').join(' ')

    unless secret_word.include?(user_in)
    else
      puts "\n#{user_in} is not part of the secret word."
      user_in.split('').join(' ')
    end
  end

  def lost(secret_word)
    puts "You used up all your tries.
    The correct word was #{secret_word}"
  end

  def won(count)
    puts "\nCongrats you won this game of hangman!
    It only took you #{count} tries to get to the secret word."
  end

  def to_yaml
    YAML.dump({
      secret_word: secret_word,
      count: count,
      player_guesses: player_guesses,
      wrong_guess: wrong_guess
    })
  end

  def from_yaml(string)
    data = YAML.load_file(string)
    puts data.inspect
    @secret_word = data[:secret_word]
    @count = data[:count]
    @player_guesses = data[:player_guesses]
    @wrong_guess = data[:wrong_guess]
  end
end

# Game set up
puts "***Hangman console game***
In this game of hangman you need to guess a secret word by entering single letters to the console. \n"

game = Hangman.new
secret_word = game.secret_word

# Ask to load the previous session and override the important instance variables
puts 'Do you want to load the last session? (y/n)'

p_load = gets.chomp
p_load.downcase!
if p_load == 'y'
  game.from_yaml('hangman_save.yml')
  game.make_guess(game.secret_word, game.player_guesses)
end

# Game flow
game.repeat(secret_word.length)
while game.count <= secret_word.length + 5

  # Give a chance to save game
  if game.count > 1
    puts 'Do you want to save the game? [y]/[n]'
    p_save = gets.chomp
    p_save.downcase!
    if p_save == 'y'
      # serialize this file
      File.open('hangman_save.yml', 'w') { |file| file.write(game.to_yaml) }
      break
    end
  end

  # User input
  puts "\nHangman. Make a guess.
  Letters you guessed so far: #{game.player_guesses}.
  But these are not part of the secret word: #{game.wrong_guess}"
  user_in = gets.chomp.downcase

  unless user_in.length == 1
    puts 'Only enter a single letter'
    user_in = gets.chomp
  end

  game.player_guesses << user_in

  attempt = game.make_guess(game.secret_word, game.player_guesses)

  game.wrong_guess << user_in if game.secret_word.include?(user_in) == false

  puts attempt
  game.count += 1

  # Won
  if game.count == secret_word.length + 5 + 1
    game.lost(secret_word)
    break
  end

  # Lost
  if attempt.include?('_') == false
    game.won(game.count)
    break
  end

end
