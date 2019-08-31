class Game < ActiveRecord::Base
  has_many :activities
  has_many :users, -> { where("activities.played = 'true'") }, through: :activities

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
end