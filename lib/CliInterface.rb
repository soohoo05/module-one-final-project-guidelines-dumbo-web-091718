class Cliinterface

  def initialize
    welcome
  end

### ----- STREAMING SERVICE LIST HELPER METHODS ---- called from in streaming options list----
  def sub_web_list(movie_name,sub_web, free_web, tv_web, buy_web, view_trailer)

    if sub_web.empty? || sub_web == nil
      puts "There are no subscription based options available at this time"
      return streaming_options_list(movie_name,sub_web, free_web, tv_web, buy_web, view_trailer)
    end
    puts "#{movie_name} is available on the following subscription web sources:"
    sub_web.each do |source|
      puts ">>>>>>>>>>>>>>>>>>"
      p source["display_name"] unless source["display_name"].nil?
      p source["link"] unless source["link"].nil?
      puts ">>>>>>>>>>>>>>>>>>"
    end
  end

  def free_web_list(movie_name,sub_web, free_web, tv_web, buy_web, view_trailer)
    if free_web.empty? || free_web == nil
      puts "There are no free streaming options available at this time"
      return streaming_options_list(sub_web, free_web, tv_web, buy_web, view_trailer)
    end
    puts "#{movie_name} is available on the following free web sources:"
    free_web.each do |source|
      puts ">>>>>>>>>>>>>>>>>>"
      p source["display_name"] unless source["display_name"].nil?
      p source["link"] unless source["link"].nil?
      puts ">>>>>>>>>>>>>>>>>>"
    end
  end

  def tv_web_list(movie_name,sub_web, free_web, tv_web, buy_web, view_trailer)
    if tv_web.empty? || tv_web == nil
      puts "There are no TV streaming options available at this time"
      return streaming_options_list(movie_name,sub_web, free_web, tv_web, buy_web, view_trailer)
    end
    puts "#{movie_name} is available on the following TV web sources:"
    tv_web.each do |source|
      puts ">>>>>>>>>>>>>>>>>>"
      p source["display_name"] unless source["display_name"].nil?
      p source["link"] unless source["link"].nil?
      puts ">>>>>>>>>>>>>>>>>>"
    end
  end

  def buy_web_list(movie_name,sub_web, free_web, tv_web, buy_web, view_trailer)
    if buy_web.empty? ||buy_web == nil
      puts "There are no streaming options to purchase at this time"
      return streaming_options_list(movie_name,sub_web, free_web, tv_web, buy_web, view_trailer)
    end
    puts "#{movie_name} is available for purchase from the following sources:"
    buy_web.each do |source|
      puts ">>>>>>>>>>>>>>>>>>"
      p source["display_name"] unless source["display_name"].nil?
      p source["link"] unless source["link"].nil?
      p source["formats"][0]["price"] unless source["formats"].nil? || source["formats"].empty?
      puts ">>>>>>>>>>>>>>>>>"
    end
  end

  def view_trailer_list(movie_name,sub_web, free_web, tv_web, buy_web, view_trailer)
     if view_trailer == nil
       puts "There are no trailers available at this time"
       return  streaming_options_list(movie_name,sub_web, free_web, tv_web, buy_web, view_trailer)
     end
       puts "View the trailer at #{view_trailer}"
   end

#### ---- RETURN LISTS OF STREAMING OPTIONS ---------------
  def streaming_options_list(movie_name, sub_web = nil, free_web = nil, tv_web = nil, buy_web = nil, view_trailer = nil)
    puts "Would you like to view avaiable streaming sources?"
    puts "A = All available streaming services"
    puts "S = Subscripton based services"
    puts "F = Free web streaming services"
    puts "T = TV web services"
    puts "B = Buy from streaming services"
    puts "V = View the trailer"
    puts "Q = Quit"
    input = gets.chomp.strip.downcase
    case input
      when "a"
        sub_web_list(movie_name,sub_web, free_web, tv_web, buy_web, view_trailer) unless sub_web.empty? || sub_web == nil?
        free_web_list(movie_name,sub_web, free_web, tv_web, buy_web, view_trailer) unless free_web.empty? || free_web == nil?
        tv_web_list(movie_name,sub_web, free_web, tv_web, buy_web, view_trailer) unless tv_web.empty? || tv_web == nil?
        buy_web_list(movie_name,sub_web, free_web, tv_web, buy_web, view_trailer) unless buy_web.empty? || buy_web == nil?
        view_trailer_list(movie_name,sub_web, free_web, tv_web, buy_web, view_trailer) unless view_trailer == nil?
      when "s"
        sub_web_list(movie_name,sub_web, free_web, tv_web, buy_web, view_trailer)
      when "f"
        free_web_list(movie_name,sub_web, free_web, tv_web, buy_web, view_trailer)
      when "t"
        tv_web_list(movie_name,sub_web, free_web, tv_web, buy_web, view_trailer)
      when "b"
        buy_web_list(movie_name,sub_web, free_web, tv_web, buy_web, view_trailer)
      when "v"
        view_trailer_list(movie_name,sub_web, free_web, tv_web, buy_web, view_trailer)
      when "q"
        exit
      else
        puts "Invalid input"
        streaming_options_list(movie_name,sub_web, free_web, tv_web, buy_web, view_trailer)
      end
    end

###---- VIEW SOURCES ----------------

def view_sources(user, movie = nil)
  if movie == nil
    movie = search(user)
  end
  call=ApiCall.new()
  movie_search = call.movie_guide.fetch_movie(movie.title)
  movie_name = movie_search.title
  sub_web = movie_search.subscription_web_sources
  free_web = movie_search.free_web_sources
  tv_web = movie_search.tv_everywhere_web_sources
  buy_web = movie_search.purchase_web_sources
  view_trailer = movie_search.web_trailers[0]["link"] unless movie_search.web_trailers.empty?
  streaming_options_list(movie_name, sub_web, free_web, tv_web, buy_web, view_trailer)
end


###---- REMOVE LIST ----- called from user commands-----
  def list_remove(user)
    user_list = List.where(user_id: user.id)

    if user_list.empty?

      puts "You have no lists to remove"
      return
    else
      p user_list.collect {|x| x.list_name}
    end

    puts "Which list do you want to remove"
    input = gets.chomp.strip
    list_to_remove = List.where(user_id: user.id, list_name: input)
    if list_to_remove.any?
      list_to_remove.destroy_all
      puts "#{input} succesfully removed"
    else
      puts "You don't have a list named '#{input}'"
      return list_remove(user)
    end
  end

### -- CREATE LIST ------ called from user commands--------
  def create_list(user)
    puts "What would you like to name your list?"
    input=gets.chomp.strip
    listquery=List.where(list_name: input, user_id: user.id)
    if listquery.empty?
      List.create(list_name: input, user_id: user.id)
      puts "You now have a new list!"
    else
      puts "That List has already been created!"
    end
  end

###----SEARCH FUNCTION ------ called from user commands -------

#<<<<<<<<< ---- FIND MOVIE WITH API CALL ---- called from in search -----
  def api_movie_call(title)
    call=ApiCall.new()
    movie_search = call.movie_guide.search_for(title)

    if movie_search.empty?
      puts "No movie found by that name, please search again"
      return search(user)
    end
    if movie_search.count > 1
      movie_arr = movie_search.collect {|x| x["title"] }
      movie_string = movie_arr.join(", ")
      puts "which movie are you searching for? '#{movie_string}'"
      input=gets.chomp.strip.downcase
      movie_var =  movie_search.find {|x| x["title"].downcase == input}
      if movie_var == nil
        puts "Invalid input, please select again."
        return api_movie_call(title)
      end
      fetch_movie = call.movie_guide.fetch_movie(movie_var["title"])
      shortened = movieHashShortner(fetch_movie)
      movie = Movie.find_or_create_by(shortened)
      movie
    else
      fetch_movie = call.movie_guide.fetch_movie(movie_search[0]["title"])
      shortened = movieHashShortner(fetch_movie)
      movie = Movie.find_or_create_by(shortened)
      movie
    end
  end

#<<<<<<<<< ----- RETURNS HASH WITH LOCAL ATTRIBUTES ----------------
  def movieHashShortner(movie)
    movie.alternate_titles.each do |title|
      AltTitles.create(api_id: movie.id, title: title)
    end
    shortened={}
    shortened["title"]=movie.title
    shortened["rating"]=movie.rating
    shortened["api_id"]=movie.id
    shortened["release_date"]=movie.release_date
    binding.pry
    shortened["director"] = movie.directors[0]["name"] unless movie.directors.empty?
    shortened
  end

#<<<<<<<-------  SEARCHES LOCAL DB FROM MOVIE -------called in side search-------
  def alt_title_helper(search_results, title, user)

    movie_names = search_results.collect {|movie| movie.title}.join(", ")
    if movie_names.empty?
      puts "No movie found by that name, please search again."
      return search(user)
    end
    puts "Are you looking for any of these #{movie_names}? Please enter the name of the movie you are looking for, or enter no."
    input = gets.chomp.downcase
    if  input == "n" || input == "no"
      movie = api_movie_call(title)
    else
      movie_select = AltTitles.where(title: input.downcase.titleize)

      if movie_select.empty?
        puts "Invalid input, please select again."
        return alt_title_helper(search_results, title, user)
      end
      movie = Movie.where(api_id: movie_select[0].api_id)[0]
    end #n or no
  end

  def display_movie_info(movie)
      binding.pry
     p "Title: #{movie["title"]}" unless movie["title"].nil?
     p "Rating: #{movie["rating"]}"
     p "Director: #{movie["director"]}" unless movie["director"].nil?
     p "Release Year: #{movie["release_date"]}"
  end

###------------- SEARCH METHOD -------------
def search(user)
  puts "Enter movie name"
  title=gets.chomp.strip

  if title == "quit" ||title == "q"
    exit
  end #q or quit

  search_results = AltTitles.where("title LIKE (?)", "%#{title}%")

  if search_results.empty?
    movie = api_movie_call(title)
    p "after api call"
    binding.pry
  else
    movie = alt_title_helper(search_results, title, user)
    p "after alt title"

  end

  display_movie_info(movie)

  view_sources(user, movie)

  puts "Would you like to save this movie to your list? put Y or N?"
  input=gets.chomp.upcase.strip
  case input
    when "Y"
      user_list = List.where(user_id: user.id)
      if user_list.any?
        puts "Which list do you want to save it on?"
        p user_list.collect {|x| x.list_name}
        input=gets.chomp.strip
        list = List.where(user_id: user.id, list_name: input)[0]
        save_to_list = MoviesOnList.where(list_id: list.id, api_id: movie.api_id)
        if save_to_list != nil
          puts "You have already saved #{movie.title} to your #{list.list_name} list."
        else
          save_to_list = MoviesOnList.create(list_id: list.id, api_id: movie.api_id)
          puts "#{movie.title} is on your '#{list.list_name}' list"
        end
      else
        puts "You have no lists!"
      end #user list any
    when "N"
      puts "Returning to menu"
    when "Q" , "QUIT"
      exit
    else
      puts "Invalid input"
  end #case input

end #class

#### ---- REMOVE MOVIE FUNCTION ---- called from user commands ---
def remove_movie_helper(title, user)
  movie=Movie.where(title: title)[0]
  if movie == nil
    puts "Invalid movie"
  else
    puts "Which list do you want to remove it from?"
    user_list = List.where(user_id: user.id)
    p user_list.collect {|x| x.list_name}
    input = gets.chomp.strip
    list_info = List.where(user_id: user.id, list_name: input)[0]
    if list_info == nil
      puts "please enter correct list name"
      return remove_movie_helper(title, user)
    end
    movie_to_destroy = MoviesOnList.where(list_id: list_info.id, api_id: movie.api_id)
    if movie_to_destroy == nil
      puts "#{title} is not on your '#{input}' list"
    else
      movie_to_destroy.destroy_all
      puts "#{title} was succesfully removed from your '#{input}' list"
    end
  end
end

def remove(user)
  puts "What movie would you like to remove"
  title=gets.chomp.strip
  if title == nil
    puts "Please enter a movie title"
    return remove(user)
  end
  remove_movie_helper(title, user)
end



### ----- LIST METHOD ----- called from user commands -----
def list(user)

  user_list = List.where(user_id: user.id)
  if user_list.empty?
    puts "You have no lists, please make one!"
    create_list(user)
  end

  p user_list.collect {|x| x.list_name}
  puts "Which list do you want to look at?"
  input = gets.chomp.strip
  list = List.where(list_name: input, user_id: user.id)[0]
  if list == nil
    puts "No list found by that name"
    list(user)
  end

  mol = MoviesOnList.where(list_id: list.id)
  list_arr = []
  mol.each do |x|
    mov_arr = Movie.all.select {|movie| movie.api_id == x.api_id}
    mov_arr.each {|y| list_arr << y.title}
  end

  if list_arr.empty?
    puts " You have no movies saved to this list"
  else
    p list_arr
  end

end

#### -------- USER COMMANDS  ----------called from user control---

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
      list_remove(user)
    when "c" #good
      create_list(user)
    when "v"
      view_sources(user)
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
    puts "V = view movie details and streaming sources"
    puts "R = remove a movie from your list"
    puts "D = delete your list"
    puts "Q = quit"

    input = gets.chomp.strip.downcase
    cases(input, user)

  end #while
end
end #class
