class Cliinterface

  def initialize
    welcome
  end

###----SEARCH FUNCTION ------ called from user commands -------
def search(user)
  puts "Enter movie name"
  title=gets.chomp.strip
  if title == "quit" ||title == "q"
    exit
  end
  movie=Movie.find_or_create_by(title: title)
  if movie == nil
    puts "Invalid input"
    #api calls
  else
  puts "Would you like to save this movie to your list? put Y or N?"
  input=gets.chomp.upcase.strip
    if input == "Y"
      puts "Which list do you want to save it on?"
      user_list = List.where(user_id: user.id)
      p user_list.collect {|x| x.list_name}
      input=gets.chomp.strip
      list = List.where(user_id: user.id, list_name: input)[0]
      save_to_list = MoviesOnList.find_or_create_by(list_id: list.id, movie_id: movie.id)
      puts "#{movie.title} is on your '#{list.list_name}' list"
    elsif input == "N"
      puts "Returning to menu"
    elsif input =="Q" || input == "QUIT"
      exit
    else
      puts "Invalid input"
    end
  end
end

#### ---- REMOVE MOVIE FUNCTION ---- called from user commands ---
def remove(user)
  puts "What movie would you like to remove"
  title=gets.chomp.strip
  movie=Movie.where(title: title)[0]
  puts "Which list do you want to remove it from ?"
  user_list = List.where(user_id: user.id)
  p user_list.collect {|x| x.list_name}
  input = gets.chomp.strip
  list_info = List.where(user_id: user.id, list_name: input)[0]
  MoviesOnList.where(list_id: list_info.id, movie_id: movie.id).destroy_all
  puts "#{title} was succesfully removed from your #{input} list"
end



### ----- LIST METHOD ----- called from user commands -----
def list(user)
  user_list = List.where(user_id: user.id)
  p user_list.collect {|x| x.list_name}
  puts "Which list do you want to look at?"
  input = gets.chomp.strip
  list = List.where(list_name: input, user_id: user.id)[0]
  mol = MoviesOnList.where(list_id: list.id)
  list_arr = []
  mol.each do |x|
    mov_arr = Movie.all.select {|movie| movie.id == x.movie_id}
    mov_arr.each {|y| list_arr << y.title}
  end
  p list_arr
end

#### -------- USER COMMANDS  ----------called from user control---
#### - test 1 complete 1012am oct 2 --------------
def cases(input, user)
  $quit = false
  case input
  when "l" #good
    list(user)
  when "s" #good
      search(user)
    when "r" #good
      remove(user)
    when "d" #good
      puts "Which list do you want to remove"
      input = gets.chomp.strip
      List.where(user_id: user.id, list_name: input).destroy_all
      puts "#{input} succesfully removed"
    when "c" #good
      puts "What would you like to name your list?"
      input=gets.chomp.strip
      List.create(list_name: input, user_id: user.id)
    when "q" #good
      $quit = true
      return $quit
    else
      puts "Invalid input"
  end #case
end #cases method

##### ------------WELCOME METHOD  ---------------
def welcome
  puts "WELCOME TO YOUR PERSONAL MOVIE GUIDE"
  puts "PLEASE ENTER YOUR USER NAME"

  name = gets.chomp.strip.capitalize
  if name=="Q" || name == "Quit"
    exit
  end
  user = User.find_or_create_by(name: name)

#### ----- ADMIN CONTROLS -----------------in welcome method----
  if user.name == "Admin"
    puts "what do you want to do?"
    puts "D = Delete User(s)"
    puts "S = See User(s)"
    input=gets.chomp.strip.capitalize
    if input == "D"
    puts "Who do you want to delete"
    input=gets.chomp.strip.capitalize
    if input == "DESTROY"
      User.destroy_all
    elsif input == "QUIT"
      exit
    else
      User.where(name: input).destroy_all
      puts "Done"
    end
elsif input == "S"
puts  User.all.collect  {|x| x.name}
puts "done"
else
  puts "Invalid input"
    #possible to do: delete all lists where list.user_id= user.id
  end
end

#####---------- USER CONTROLS ----------------in welcome method----
  until $quit == true
    puts "Hello #{user.name}!"
    puts "What do you wanna do today?: "
    puts "C = create a list "
    puts "L = return your list"
    puts "S = search for a movie"
    puts "R = remove a movie from your list"
    puts "D = delete your list"
    puts "Q = quit"

    input = gets.chomp.strip.downcase
    cases(input, user)

  end #while
end
end #class
