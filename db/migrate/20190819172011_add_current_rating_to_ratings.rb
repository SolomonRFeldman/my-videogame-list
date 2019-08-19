class AddCurrentRatingToRatings < ActiveRecord::Migration[5.2]
  def change
    add_column :ratings, :current_rating, :bool
  end
end
