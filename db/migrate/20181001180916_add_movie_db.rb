class AddMovieDb < ActiveRecord::Migration[5.0]
  def change
    create_table :movies do |t|
      t.string :title
      t.string :genre
      t.string :rating
      t.string :director
      t.integer :user_rating
      t.integer :release_date
      # t.string :actor_1
      # t.string :actor_2
      # t.string :actor_3
    end
  end
end
