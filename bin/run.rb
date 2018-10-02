require_relative '../config/environment'
# require 'net/http'
# require 'open-uri'
# require 'json'
# test = test_api.rb
require 'pry'

def search(user)
  puts "Enter movie name"
  title=gets.chomp
  movie=Movies.find_by(title: title)
  if movie == nil
    puts "Invalid input"
  else
  puts "Would you like to save this movie to your list? put Y or N?"
  input=gets.chomp
    if input == "Y"
      puts "Which list do you want to save it on?"
      input=gets.chomp
      # user.save(input,movie)
    elsif input == "N"
      puts "Returning to menu"
    else
      puts "Invalid input"
    end
end
end

def cases(input, user)
  $quit = false
  case input
    # binding.pry
  when "l"
      Lists.find(user.id)
    when "s"
      search(user)
    when "r"
      puts "What movie would you like to remove"
      title=gets.chomp
      movie=Movies.where(title: title)
      Lists.where(user.id, movie.id).destroy
    when "d"
      Lists.where(user.id).destroy
    when "c"
      puts "What would you like to name your list?"
      input=gets.chomp
      Lists.create(list_name: input, user_id: user.id)
    when "q"
      $quit = true
      return $quit
    else
      puts "Invalid input"
  end #case
end #cases method

puts "WELCOME TO YOUR PERSONAL MOVIE GUIDE"
puts "PLEASE ENTER YOUR USER NAME"
name = gets.chomp.capitalize

user = User.find_or_create_by(name: name)

until $quit == true
  puts "Hello #{user.name}!"
  puts "What do you wanna do today?: "
  puts "C = create a list "
  puts "L = return your list"
  puts "S = search for a movie"
  puts "R = remove a movie from your list"
  puts "D = delete your list"
  puts "Q = quit"

  input = gets.chomp.downcase
  cases(input, user)

end #while
