class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  has_one :user_game
  belongs_to :rating, optional: true
  
  validates :user_id, presence: true
  validates :game_id, presence: true
  validates :content, presence: true
end