class ViewingSources < ActiveRecord::Migration[5.0]
  def change
    create_table :sources do |t|
      t.integer :api_id
    end
  end
end
