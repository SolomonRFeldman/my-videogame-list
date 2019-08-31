class Feed

  def self.activities
    Activity
      .joins(activity_joins)
      .select(activity_columns)
      .order("activities.created_at DESC")
      .limit(20)
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

end