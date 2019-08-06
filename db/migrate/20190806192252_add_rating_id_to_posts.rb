class AddRatingIdToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :rating_id, :integer
  end
end
