class AddMoviesToList < ActiveRecord::Migration[5.0]
  def change
    create_table :movies_on_lists do |t|
      t.integer :list_id
      t.integer :movie_id
    end
  end
end
