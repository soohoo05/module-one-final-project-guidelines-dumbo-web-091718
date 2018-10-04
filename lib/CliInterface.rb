
class Cliinterface

  def initialize
@prompt=TTY::Prompt.new

puts    "  ███╗   ███╗ ██████╗ ██╗   ██╗██╗███████╗     ██████╗ ██╗   ██╗██╗██████╗ ███████╗".red
puts    "  ████╗ ████║██╔═══██╗██║   ██║██║██╔════╝    ██╔════╝ ██║   ██║██║██╔══██╗██╔════╝".yellow
puts    "  ██╔████╔██║██║   ██║██║   ██║██║█████╗      ██║  ███╗██║   ██║██║██║  ██║█████╗".magenta
puts    "  ██║╚██╔╝██║██║   ██║╚██╗ ██╔╝██║██╔══╝      ██║   ██║██║   ██║██║██║  ██║██╔══╝".green
puts    "  ██║ ╚═╝ ██║╚██████╔╝ ╚████╔╝ ██║███████╗    ╚██████╔╝╚██████╔╝██║██████╔╝███████╗".blue
puts    "  ╚═╝     ╚═╝ ╚═════╝   ╚═══╝  ╚═╝╚══════╝     ╚═════╝  ╚═════╝ ╚═╝╚═════╝ ╚══════╝".cyan

  puts    "
                            .       ...,**//#&&@@&&&&@@&&%#((/*.
                                      .,,*(%&@@@@@@@&@@@@@&(*,
                                       .,///#%&&@@@@@@@@@@&%#(*,
    ,,.       /, ((                    .,****/#%#%%%&%%%(/*//,
    ,..       *  ./.                  ,.     **     ..,.  .
    ,,.       ,  ,*                                 .,
    .,        .  **                                 .
    .,     ,.,.  */               .                ,@@     ..*..
    ..     *,*.  **                               .(&@#     ...
    ..     //(,  **                              .(%@@&(.
           ,,(,  **                             .,#%&@@%*.
           .,(,  /,                    ...,,,,*,.*..,*/,*(,,...
           .((,  /,                   ....,,,,,*.,,.. ........
           *&/.  /,                    ......,(%(. ......*%,
           *#*,  *,           .           ..,(((//(//,*&&%#(*
           ././ .(,                       ..//,,.      .  /,*,
            , &/.(,                       .,/*  .*/(#####, .,*
            . *  /,.                       .*#/*,,.......,/#/,
              .  ,,                         .,,,,,,,,,,....*,
              .  *.                           ...,,*/(//*.
                 ,,                            .,,***,,..,*.
        .        ,,                              ........            %.
                 ,,                                  ..        .     . */.#
                 ((                                            .       ..,*&%&.
                 ,.@.   *....                  ..,,,,,..       ..       ./,,,.(,(
                 .     .&,#.                   ...,,,,..        .         %%%     ,
                 .  .%@@,*@*               .   ....,....      .. .         /&%,
                   %&&@%( ,,     (         ..   .......    ..... .  .       @&%(    .
                  /%&&* .                ...  .......     ......  ..      .%%#%/
                 */%%*  ,  ., .           ............    ......   *..     @/%(%#*
                  .,(#( * *%&%%&@.         .............   . ......    . , ..&* ./(%*              "


    welcome
  end

  ###---- EMAIL MAKER ----- adds email to user account on first instance-----------
  def email_maker
    puts "Please enter your email"
    email = gets.chomp
    if email.match(URI::MailTo::EMAIL_REGEXP).present?
      @user.email = email
      @user.save
    else
      puts "Email invalid"
      return email_maker
    end
    user_controls
  end


  #####---------- USER CONTROLS ----------------in welcome method----
  def user_controls
    until $quit == true
      puts "Hello #{@user.name}!"
      choices={
        "Create a list" => -> do cases('c') end,
        "Return your list"=> -> do cases('l') end,
        "Search for a movie" => -> do cases('s') end,
        "View movie details and streaming sources"=> -> do cases('v') end,
        "Remove a movie from your list"=> -> do cases('r') end,
        "Delete your list"=> -> do cases('d') end,
        "Quit" => -> do exit end
      }
        @prompt.select("What do you wanna do today?:",choices)
    end
  end

####----- SAVER METHOD --------- called from in search method
  def saver(movie)
    puts "Would you like to save this movie to your list? put Y or N?"
    input=gets.chomp.upcase.strip
    case input
      when "Y"
        user_list = List.where(user_id: @user.id)
        if user_list.any?
          puts "Which list do you want to save it on?"
          p user_list.collect {|x| x.list_name}
          input=gets.chomp.strip
          list = List.where(user_id: @user.id, list_name: input)[0]
          if list == nil
            puts "You have no list by that name"
           return saver(movie)
          end
          save_to_list = MoviesOnList.where(list_id: list.id, api_id: movie.api_id)

          if !save_to_list.empty?
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
    end

#####----INPUT CHECKER -------------------------------
  def input_checker(input)
    input_var = input.split(" ")
    input_var.each do |x|
     if  x.match(/^[a-z\d\-_s]+$/i).nil?
       return true
     end
   end
   return false
  end

### ----- STREAMING SERVICE LIST HELPER METHODS ---- called from in streaming options list----
  def sub_web_list(movie, sub_web, free_web, tv_web, buy_web, view_trailer)

    if sub_web.empty? || sub_web == nil
      puts "There are no subscription based options available at this time".red
      return streaming_options_list(movie, sub_web, free_web, tv_web, buy_web, view_trailer)
    end
    puts "#{movie.title} is available on the following subscription web sources:".white
    sub_web.each do |source|
      puts ">>>>>>>>>>>>>>>>>>".blue
      p source["display_name"] unless source["display_name"].nil?
      p source["link"] unless source["link"].nil?
      puts "..................".blue
    end
  end

  def free_web_list(movie, sub_web, free_web, tv_web, buy_web, view_trailer)
    if free_web.empty? || free_web == nil
      puts "There are no free streaming options available at this time".red
      return streaming_options_list(movie, sub_web, free_web, tv_web, buy_web, view_trailer)
    end
    puts "#{movie.title} is available on the following free web sources:".white
    free_web.each do |source|
      puts ">>>>>>>>>>>>>>>>>>".blue
      p source["display_name"] unless source["display_name"].nil?
      p source["link"] unless source["link"].nil?
      puts "..................".blue
    end
  end

  def tv_web_list(movie, sub_web, free_web, tv_web, buy_web, view_trailer)
    if tv_web.empty? || tv_web == nil
      puts "There are no TV streaming options available at this time".red
      return streaming_options_list(movie, sub_web, free_web, tv_web, buy_web, view_trailer)
    end
    puts "#{movie.title} is available on the following TV web sources:".white
    tv_web.each do |source|
      puts ">>>>>>>>>>>>>>>>>>".blue
      p source["display_name"] unless source["display_name"].nil?
      p source["link"] unless source["link"].nil?
      puts "..................".blue
    end
  end

  def buy_web_list(movie, sub_web, free_web, tv_web, buy_web, view_trailer)
    if buy_web.empty? ||buy_web == nil
      puts "There are no streaming options to purchase at this time".red
      return streaming_options_list(movie, sub_web, free_web, tv_web, buy_web, view_trailer)
    end
    puts "#{movie.title} is available for purchase from the following sources:".white
    buy_web.each do |source|
      puts ">>>>>>>>>>>>>>>>>>".blue
      p source["display_name"] unless source["display_name"].nil?
      p source["link"] unless source["link"].nil?
      p source["formats"][0]["price"] unless source["formats"].nil? || source["formats"].empty?
      puts "..................".blue
    end
  end

  def view_trailer_list(movie, sub_web, free_web, tv_web, buy_web, view_trailer)
     if view_trailer == nil
       puts "There are no trailers available at this time".red
       return  streaming_options_list(movie, sub_web, free_web, tv_web, buy_web, view_trailer)
     end
       puts "View the trailer at #{view_trailer.blue}".white
   end

#### ---- RETURN LISTS OF STREAMING OPTIONS ---------------
  def streaming_options_list(movie, sub_web = nil, free_web = nil, tv_web = nil, buy_web = nil, view_trailer = nil)
    choices={
      "All available streaming services" => -> do output = ('a') end,
      "Subscripton based services"=> -> do output = ('s') end,
      "Free web streaming services" => -> do output = ('f') end,
      "TV web services"=> -> do output = ('t') end,
      "Buy from streaming services"=> -> do output = ('b') end,
      "View the trailer"=> -> do output = ('v') end,
      "Save to your list"=> -> do output = ('l') end,
      "Email all info to your list" => -> do output = ('e') end,
      "Quit" => -> do exit end
    }
    output = @prompt.select("Would you like to view avaiable streaming sources?", choices)

    case output
      when "e"

      when "a"
        sub_web_list(movie,sub_web, free_web, tv_web, buy_web, view_trailer) unless sub_web.empty? || sub_web == nil?
        free_web_list(movie,sub_web, free_web, tv_web, buy_web, view_trailer) unless free_web.empty? || free_web == nil?
        tv_web_list(movie,sub_web, free_web, tv_web, buy_web, view_trailer) unless tv_web.empty? || tv_web == nil?
        buy_web_list(movie,sub_web, free_web, tv_web, buy_web, view_trailer) unless buy_web.empty? || buy_web == nil?
        view_trailer_list(movie,sub_web, free_web, tv_web, buy_web, view_trailer) unless view_trailer == nil?
        saver(movie)
      when "s"
        sub_web_list(movie,sub_web, free_web, tv_web, buy_web, view_trailer)
      when "f"
        free_web_list(movie,sub_web, free_web, tv_web, buy_web, view_trailer)
      when "t"
        tv_web_list(movie,sub_web, free_web, tv_web, buy_web, view_trailer)
      when "b"
        buy_web_list(movie,sub_web, free_web, tv_web, buy_web, view_trailer)
      when "v"
        view_trailer_list(movie,sub_web, free_web, tv_web, buy_web, view_trailer)
      when "l"
        saver(movie)
      else
        puts "Invalid input"
        streaming_options_list(movie,sub_web, free_web, tv_web, buy_web, view_trailer)
      end
    end

###---- VIEW SOURCES ----------------

def view_sources(movie = nil)
  if movie == nil
    return search
  end
  call=ApiCall.new()

  movie_search = call.movie_guide.fetch_movie(movie.title)
  movie_name = movie_search.title
  sub_web = movie_search.subscription_web_sources
  free_web = movie_search.free_web_sources
  tv_web = movie_search.tv_everywhere_web_sources
  buy_web = movie_search.purchase_web_sources
  view_trailer = movie_search.web_trailers[0]["link"] unless movie_search.web_trailers.empty?
  streaming_options_list(movie, sub_web, free_web, tv_web, buy_web, view_trailer)
end


###---- REMOVE LIST ----- called from user commands-----
  def list_remove
    user_list = List.where(user_id: @user.id)

    if user_list.empty?
      puts "You have no lists to remove"
      return
    else
      p user_list.collect {|x| x.list_name}
    end

    puts "Which list do you want to remove"
    input = gets.chomp.strip
    list_to_remove = List.where(user_id: @user.id, list_name: input)
    if list_to_remove.any?
      list_to_remove.destroy_all
      puts "#{input} succesfully removed"
    else
      puts "You don't have a list named '#{input}'"
      return list_remove
    end
  end

### -- CREATE LIST ------ called from user commands--------
  def create_list
    puts "What would you like to name your list?"
    input=gets.chomp.strip
    if input == nil
      puts "Invalid list name"
      create_list
    end
    listquery=List.where(list_name: input, user_id: @user.id)
    if listquery.empty?
      List.create(list_name: input, user_id: @user.id)
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
      return search
    end
    if movie_search.count > 1
      movie_arr = movie_search.collect {|x| x["title"] }
      # movie_string = movie_arr.join(", ")
      puts "which movie are you searching for?"
      movie_arr.each do |title|
        puts title.white
      end

      input=gets.chomp.strip.downcase
      movie_arr_2 =  movie_search.select do |movie|
        movie["title"].downcase == input
      end
      movie_var = movie_arr_2[0]
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
    shortened["director"] = movie.directors[0]["name"] unless movie.directors.empty?
    shortened
  end

#<<<<<<<-------  SEARCHES LOCAL DB FROM MOVIE -------called in side search-------
  def alt_title_helper(search_results, title)
    movie_names = search_results.collect {|movie| movie.title}

    if movie_names.empty?
      puts "No movies found by that name, please search again."
      return search
    end

    movie_names.each do |title|
     puts title.white
    end

    puts "Please enter the name of the movie you are looking for, or enter no."
    input = gets.chomp.downcase
    if  input == "n" || input == "no"
      movie = api_movie_call(title)
    else
      movie_select =  AltTitles.all.select do |movie|
        movie.title.downcase == input
      end
      movie_all = Movie.all.select do |movie|
        movie.title.downcase == input
      end
      if movie_select.empty? && movie_all.empty?
        puts "Invalid input, please select again."
        return alt_title_helper(search_results, title)
      elsif movie_select.empty?
        movie = Movie.where(api_id: movie_all[0].api_id)[0]
      else
        movie = Movie.where(api_id: movie_select[0].api_id)[0]
      end #n or no
    end
  end

### ------ DISPLAY MOVIE INFO ----- puts movie details to console -------

  def display_movie_info(movie)
     puts ("Title: #{movie["title"]}").white unless movie["title"].nil?
     puts ("Rating: #{movie["rating"]}").white unless movie["rating"].nil?
     puts ("Director: #{movie["director"]}").white unless movie["director"].nil?
     puts ("Release Year: #{movie["release_date"]}").white unless movie["release_date"].nil?
  end

###------------- SEARCH METHOD -------------
def search
  puts "Enter movie name"
  title=gets.chomp.strip

  if title == "quit" ||title == "q"
    exit
  end #q or quit

  search_results = AltTitles.where("title LIKE (?)", "%#{title}%")

  if search_results.empty?
    movie = api_movie_call(title)
  else
    movie = alt_title_helper(search_results, title)
  end

  display_movie_info(movie)
  view_sources(movie)
end #class

#### ---- REMOVE MOVIE FUNCTION ---- called from user commands ---
def remove_movie_helper(title)
  movie=Movie.where(title: title.downcase.titleize)[0]

  if movie == nil
    puts "Invalid movie"
  else
    puts "Which list do you want to remove it from?"
    user_list = List.where(user_id: @user.id)
    p user_list.collect {|x| x.list_name}
    input = gets.chomp.strip
    if input_checker(input)
      puts "Please enter a valid list name"
      return remove_movie_helper(title)
    end
    list_info = List.where(user_id: @user.id, list_name: input)[0]
    if list_info == nil
      puts "please enter correct list name"
      return remove_movie_helper(title)
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

def remove
  puts "What movie would you like to remove"
  title=gets.chomp.strip
  if input_checker(title)
    puts "Please enter a valid movie title"
    return remove
  end
  remove_movie_helper(title)
end



### ----- LIST METHOD ----- called from user commands -----
  def list

    user_list = List.where(user_id: @user.id)
    if user_list.empty?
      puts "You have no lists, please make one!"
      create_list
    end

    p user_list.collect {|x| x.list_name}
    puts "Which list do you want to look at? Type M to return to the main menu."
    input = gets.chomp.strip
    if input == "m" || input == "M"
      return user_controls
    end
    list_var = List.where(list_name: input, user_id: @user.id)[0]

    if list_var == nil
      puts "No list found by that name"
      list
    end

    mol = MoviesOnList.where(list_id: list_var.id)
    list_arr = []
    mol.each do |x|
      mov_arr = Movie.all.select {|movie| movie.api_id == x.api_id}
      mov_arr.each {|y| list_arr << y.title}
    end

    if list_arr.empty?
      puts " You have no movies saved to this list. Type M to return to the main menu."
      return list
    else
      p list_arr
    end



  end

#### -------- USER COMMANDS  ----------called from user control---

def cases(input)
  $quit = false
  case input
  when "l" #good
    list
  when "s" #good
      search
    when "r" #good
      remove
    when "d" #good
      list_remove
    when "c" #good
      create_list
    when "v"
      view_sources
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
      return exit
    end

    if input_checker(name)
      puts "Not a valid name"
      return welcome
    end

    @user = User.where(name: name)[0]
    password=""
    if @user != nil
      password = @prompt.mask("PLEASE ENTER YOUR PASSWORD")
      password.split(" ").each do |char|
        if char == " "
          puts "Not a valid password"
          return welcome
        end
      end
    end

    if @user == nil
      password = @prompt.mask("PLEASE MAKE YOUR PASSWORD")
      password.split(" ").each do |char|
        if char == " "
          puts "Not a valid password"
          return welcome
        end
        @user = User.create(name: name, password: password)
      end
      email_maker
    end
binding.pry
    if @user.password == password
      user_controls
    else
      puts "Invalid password"
      return welcome
    end

  #### ----- ADMIN CONTROLS -----------------in welcome method----
    if @user.name == "Admin"
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

    user_controls
  end

end #class
