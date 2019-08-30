class DropPostsAndUserGamesAndRatings < ActiveRecord::Migration[5.2]
  def change
    drop_table :posts
    drop_table :user_games
    drop_table :ratings
  end
end