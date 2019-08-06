class AddTimestampsToUsersAndRatings < ActiveRecord::Migration[5.2]
  def change
    change_table(:ratings) { |t| t.timestamps }
    change_table(:users) { |t| t.timestamps }
  end
end
