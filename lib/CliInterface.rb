class Cliinterface

  def initialize
    welcome
  end

###----SEARCH FUNCTION ------ called from user commands -------
def search(user)
  puts "Enter movie name"
  title=gets.chomp.strip
  movie=Movie.find_or_create_by(title: title)
  if movie == nil
    puts "Invalid input"
  else
  puts "Would you like to save this movie to your list? put Y or N?"
  input=gets.chomp.upcase.strip
    if input == "Y"
      puts "Which list do you want to save it on?"
      input=gets.chomp.strip
      # user.save(input,movie)
      list = List.where(user_id: user.id, list_name: input)[0]
      # binding.pry
      save_to_list = MoviesOnList.create(list_id: list.id, movie_id: movie.id)
      if save_to_list != nil
          # binding.pry
        puts "#{movie.title} has been saved to your '#{list.list_name}' list"

      end
    elsif input == "N"
      puts "Returning to menu"
    else
      puts "Invalid input"
    end
  end
end

#### -------- USER COMMANDS  ----------called from user control---
#### - test 1 complete 1012am oct 2 --------------
def cases(input, user)
  $quit = false
  case input
    # binding.pry
  when "l"
      # binding.pry
      user_list = List.where(user_id: user.id)
      p user_list.collect {|x| x.list_name}
      puts "Which list do you want to look at?"
      input = gets.chomp.strip
      list = List.where(list_name: input)[0]
      MoviesOnList.where(id: list.id)
    when "s"
      search(user)
    when "r"
      puts "What movie would you like to remove"
      title=gets.chomp.strip
      movie=Movies.where(title: title)
      List.where(user.id, movie.id).destroy
    when "d"
      puts "Which list do you want to remove"
      input = gets.chomp.strip
      List.where(user_id: user.id, list_name: input).destroy_all
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
  user = User.find_or_create_by(name: name)

#### ----- ADMIN CONTROLS -----------------in welcome method----
  if user.name == "Admin"
    puts "what user do you want to delete?"
    input=gets.chomp.strip
    if input == "DESTROY"
      User.destroy_all
    else
      User.where(name: input).destroy_all
    end
    #possible to do: delete all lists where list.user_id= user.id
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
