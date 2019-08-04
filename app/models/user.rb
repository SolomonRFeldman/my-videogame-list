class User < ActiveRecord::Base
  has_secure_password
  has_many :games, through: :user_games
  has_many :posts
  has_many :ratings
  
  validates :username, :email, presence: true
  validates :username, :email, uniqueness: { case_sensitive: false }

end