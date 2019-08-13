class AddPostIdToUserGames < ActiveRecord::Migration[5.2]
  def change
    add_column :user_games, :post_id, :integer
  end
end
