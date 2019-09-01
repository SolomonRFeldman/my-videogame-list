class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  
  validates :user_id, presence: true
  validates :game_id, presence: true
  validate :presence_validation
  validates :user_id, uniqueness: { scope: [:game_id, :current_rating] }, if: :current_rating
  validates :user_id, uniqueness: { scope: [:game_id, :played] }, if: :played

  def presence_validation
    unless rating || !post_content.empty? || played
      errors.add(:rating, "can't be blank with a blank post")
      errors.add(:post, "can't be blank with a blank rating")
    end
  end

  before_create do
    if self.rating
      if old_rating = Activity.find_by(user_id: user_id, game_id: game_id, current_rating: true)
        old_rating.update(current_rating: false)
      end
      self.current_rating = true
    end
  end

  def check_rating
    if self.rating
      unless Activity.find_by("created_at > '#{self.created_at}' AND rating IS NOT NULL AND user_id = #{self.user_id} AND game_id = #{self.game_id}")
        if old_rating = Activity.find_by(user_id: user_id, game_id: game_id, current_rating: true)
          old_rating.update(current_rating: false)
        end
        self.current_rating = true
      end
    else
      self.current_rating = nil
    end
  end
  
end