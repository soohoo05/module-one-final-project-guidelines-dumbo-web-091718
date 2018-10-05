class AddMovieDb < ActiveRecord::Migration[5.0]
  def change
    create_table :movies do |t|
      t.string :title
      t.string :genre
      t.string :rating
      t.string :director
      t.integer :release_date
      t.text :description
    end
  end
end
