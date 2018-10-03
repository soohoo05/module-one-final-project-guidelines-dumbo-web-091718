class AddAltTitles < ActiveRecord::Migration[5.0]
  def change
    create_table :alt_titles do |t|
      t.integer :api_id
      t.string :title
    end
  end
end
