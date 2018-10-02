class MoviesOnList < ActiveRecord::Base
  belongs_to :list
  belongs_to :user, :through :list
  belongs_to :movie
end
