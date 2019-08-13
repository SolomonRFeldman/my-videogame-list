class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  has_one :user_game

  validates :content, presence: true
end