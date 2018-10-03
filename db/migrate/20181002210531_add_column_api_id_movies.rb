class AddColumnApiIdMovies < ActiveRecord::Migration[5.0]
  def change
    add_column :movies, :api_id, :integer
  end
end
