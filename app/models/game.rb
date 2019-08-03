class Game < ActiveRecord::Base
  #update rating will multiply current number of ratings by rating, add in the new one, and divide by new number of ratings
  has_many :users, through: :user_games
  has_many :posts
  has_many :ratings
end