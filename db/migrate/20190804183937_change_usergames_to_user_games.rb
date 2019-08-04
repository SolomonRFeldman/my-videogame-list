class ChangeUsergamesToUserGames < ActiveRecord::Migration[5.2]
  def change
    rename_table :usergames, :user_games
  end
end
