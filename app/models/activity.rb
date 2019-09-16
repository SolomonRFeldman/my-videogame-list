class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  
  validates :user_id, presence: true
  validates :game_id, presence: true
  validate :presence_validation
  validates :user_id, uniqueness: { scope: [:game_id, :current_rating] }, if: :current_rating
  validates :user_id, uniqueness: { scope: [:game_id, :played] }, if: :played

  def presence_validation
    unless rating || !post_content.empty? || played
      errors.add(:rating, "can't be blank with a blank post")
      errors.add(:post, "can't be blank with a blank rating")
    end
  end

  before_create do
    if self.rating
      if old_rating = Activity.find_by(user_id: user_id, game_id: game_id, current_rating: true)
        old_rating.update(current_rating: false)
      end
      self.current_rating = true
    end
  end

  def edit_activity(params)
    self.assign_attributes(params)
    self.check_rating if self.valid?
    self.save
  end

  def check_rating
    if self.rating
      unless Activity.find_by("created_at > '#{self.created_at}' AND rating IS NOT NULL AND user_id = #{self.user_id} AND game_id = #{self.game_id}")
        if old_rating = Activity.find_by(user_id: user_id, game_id: game_id, current_rating: true)
          old_rating.update(current_rating: false)
        end
        self.current_rating = true
      end
    else
      self.current_rating = nil
    end
  end

  def associated
    Activity.user_game_activities(user_id, game_id)
  end
  
  def self.feed
      joins(activity_joins)
      .select(activity_columns)
      .order("activities.created_at DESC")
      .limit(20)
  end

  def self.game_list
      select(game_list_columns)
      .order("activities.created_at DESC")
      .where("activities.played = 'true'")
  end

  def self.game_rating(game_id)
    where("game_id = '#{game_id}' AND current_rating = 'true'")
    .average("rating")
  end

  def self.user_game_activities(user_id, game_id)
    where("user_id = #{user_id} AND game_id = #{game_id}")
  end

  private
  
  def self.activity_joins
    <<~SQL
      JOIN users ON activities.user_id = users.id
      JOIN games ON activities.game_id = games.id
    SQL
  end

  def self.activity_columns
    <<~SQL
      activities.id,
      users.id AS user_id,
      games.id AS game_id,
      users.username AS username,
      games.name AS game_name,
      rating,
      post_content,
      CASE
        WHEN post_content != '' AND played IS NOT NULL
          THEN 'composite'
        WHEN post_content != '' AND played IS NULL
          THEN 'post'
        WHEN post_content = '' AND played IS NOT NULL
          THEN 'played'
      END AS type
    SQL
  end

  def self.game_list_columns
    <<~SQL
      (SELECT games.name FROM games WHERE games.id = activities.game_id),
      ( 
        SELECT rating.rating FROM activities AS rating 
        WHERE rating.user_id = activities.user_id AND rating.game_id = activities.game_id AND rating.current_rating = true
      )
    SQL
  end

end