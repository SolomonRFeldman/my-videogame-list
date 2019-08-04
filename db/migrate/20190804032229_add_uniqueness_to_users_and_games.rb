class AddUniquenessToUsersAndGames < ActiveRecord::Migration[5.2]
  def change
    enable_extension :citext
    change_column :users, :username, :citext
    add_index :users, :username, unique: true

    change_column :users, :email, :citext
    add_index :users, :email, unique: true

    change_column :games, :name, :citext
    add_index :games, :name, unique: true
  end
end
