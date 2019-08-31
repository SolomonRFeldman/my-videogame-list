class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  
  validates :user_id, presence: true
  validates :game_id, presence: true
  validates :user_id, uniqueness: { scope: [:game_id, :current_rating] }, if: :current_rating
  validates :user_id, uniqueness: { scope: [:game_id, :played] }, if: :played

  before_create do
    if self.current_rating == nil
      if old_rating = Activity.find_by(user_id: user_id, game_id: game_id, current_rating: true)
        old_rating.update(current_rating: false)
      end
      self.current_rating = true
    end
  end
  
end