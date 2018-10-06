class AddUserList < ActiveRecord::Migration[5.0]
  def change
    create_table :lists do |t|
      t.integer :user_id
      t.integer :title_id
      t.string :list_name
    end
  end
end
