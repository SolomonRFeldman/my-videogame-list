class Game < ActiveRecord::Base
  has_many :user_games
  has_many :users, through: :user_games
  has_many :posts
  has_many :ratings

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
end