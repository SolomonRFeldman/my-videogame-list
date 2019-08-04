class AddUniquenessToUserGames < ActiveRecord::Migration[5.2]
  def change
    add_index :user_games, [:user_id, :game_id], unique: true
  end
end
