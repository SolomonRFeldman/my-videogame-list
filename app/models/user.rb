class User < ActiveRecord::Base
  has_secure_password
  has_many :activities
  has_many :games, -> { where("activities.played = 'true'") }, through: :activities
  
  validates :username, :email, presence: true
  validates :username, :email, uniqueness: { case_sensitive: false }

end