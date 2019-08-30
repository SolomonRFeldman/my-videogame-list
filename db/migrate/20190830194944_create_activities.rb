class CreateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :activities do |t|
      t.integer :user_id
      t.integer :game_id
      t.string :post_content
      t.float :rating
      t.boolean :current_rating
      t.boolean :played
      t.timestamps
    end
  end
end
