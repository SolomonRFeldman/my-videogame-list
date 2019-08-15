class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  has_one :user_game
  has_one :post

end