class AddRatingIdToUserGames < ActiveRecord::Migration[5.2]
  def change
    add_column :user_games, :rating_id, :integer
  end
end
