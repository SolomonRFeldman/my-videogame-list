class AddUniquenessToActivitiesWhenCurrentIsTrueAndWhenPlayedIsTrue < ActiveRecord::Migration[5.2]
  def change
    add_index :activities, [:user_id, :game_id, :current_rating], where: 'current_rating IS true', unique: true
    add_index :activities, [:user_id, :game_id, :played], where: 'played IS true', unique: true
  end
end
