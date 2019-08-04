class AddTimestampToPosts < ActiveRecord::Migration[5.2]
  def change
    change_table(:posts) { |t| t.timestamps }
  end
end
