class RemoveRatingFromGames < ActiveRecord::Migration[5.2]
  def change
    remove_column :games, :rating
  end
end
