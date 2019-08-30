class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  
  validates :user_id, presence: true
  validates :game_id, presence: true
  validates :user_id, uniqueness: { scope: [:game_id, :current_rating] }, if: :current_rating
  validates :user_id, uniqueness: { scope: [:game_id, :played] }, if: :played
end