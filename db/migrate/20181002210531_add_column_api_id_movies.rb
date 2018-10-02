class AddColumnApiIdMovies < ActiveRecord::Migration[5.0]
  def change
    add_column :movies, :apiId, :integer
  end
end
