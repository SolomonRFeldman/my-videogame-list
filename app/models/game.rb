class Game < ActiveRecord::Base
  has_many :users, through: :user_games
  has_many :posts
  has_many :ratings
end