class AddTimestampsToUserGames < ActiveRecord::Migration[5.2]
  def change
    change_table(:user_games) { |t| t.timestamps }
  end
end
