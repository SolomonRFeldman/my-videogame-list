class UserGame < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  belongs_to :post, optional: true

  validates :user_id, uniqueness: { scope: :game_id }
end