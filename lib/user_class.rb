class User < ActiveRecord::Base
  has_many :lists
  has_many :movies, through: :lists

  def make_list(name)
    new_list = List.new
    new_list.list_name = name
    new_list.user_id = self.id
  end

  def add_movie_to_list(list, movie)
    list_item = MoviesOnList.new
    list_item.list_id = list.id
    list_item.movie_id = movie.id
    # list_name.user_id = self.id
  end

  def save(list_name, movie)
    list = self.lists
    new_save = MoviesOnList.create
    new_save.list_id = list.where(user_id: self.id, list_name: list_name)[0]
    new_save.movie_id = movie.id
  end

  def remove_movie(movie, list)
    list.where(movie_id: movie.id).destroy
  end

end
