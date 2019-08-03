class User < ActiveRecord::Base
  has_many :games, through: :user_games
  has_many :posts
  has_many :ratings

  has_secure_password
end