class AddUniquenessToRatingWhenCurrentIsTrue < ActiveRecord::Migration[5.2]
  def change
    add_index :ratings, [:user_id, :game_id], where: 'current_rating IS true', unique: true
  end
end
