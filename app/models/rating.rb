class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  has_one :user_game
  has_one :post
  
  validates :user_id, uniqueness: { scope: [:game_id, :current_rating] }, if: :current_rating
  validates :rating, presence: true

  before_create do
    if old_rating = Rating.find_by(user_id: user_id, game_id: game_id, current_rating: true)
      old_rating.current_rating = false
      old_rating.save
    end
    self.current_rating = true
  end

end