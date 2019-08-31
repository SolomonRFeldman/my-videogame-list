class Feed

  def self.activities
    Activity
      .joins(activity_joins)
      .select(activity_columns)
      .order("activities.created_at DESC")
      .limit(20)
  end

  def self.game_list
    Activity
      .select(game_list_columns)
      .order("activities.created_at DESC")
      .where("activities.played = 'true'")
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