class Feed
  
  def self.activities
    UserGame
      .joins(feed_joins)
      .select(feed_columns)
      .order("created_at DESC")
      .limit(20)
  end
  
  def self.game_list
    User
      .joins("RIGHT JOIN user_games ON user_games.user_id = users.id")
      .select(game_list_columns)
      .order("user_games.created_at DESC")
  end

  private
  
  def self.feed_joins
    <<~SQL
      FULL JOIN posts ON user_games.post_id = posts.id
      LEFT JOIN ratings AS rating1 ON user_games.rating_id = rating1.id OR posts.rating_id = rating1.id
      FULL JOIN ratings ON rating1.id = ratings.id
      JOIN users ON user_games.user_id = users.id OR posts.user_id = users.id OR ratings.user_id = users.id
    SQL
  end

  def self.feed_columns
    <<~SQL
      COALESCE (posts.user_id, user_games.user_id, ratings.user_id) AS user_id,
      COALESCE (posts.game_id, user_games.game_id, ratings.game_id) AS game_id,
      COALESCE (posts.created_at, user_games.created_at, ratings.created_at) AS created_at,
      COALESCE (
        (SELECT games.name FROM games WHERE user_games.game_id = games.id),
        (SELECT games.name FROM games WHERE posts.game_id = games.id),
        (SELECT games.name FROM games WHERE ratings.game_id = games.id)
      ) AS game_name,
      users.username,
      posts.content AS post_content,
      ratings.rating AS game_rating,
      CASE
        WHEN posts.user_id IS NOT NULL AND user_games.user_id IS NOT NULL
        THEN 'composite'
      WHEN posts.user_id IS NOT NULL AND user_games.user_id IS NULL
        THEN 'post'
      WHEN posts.user_id IS NULL AND user_games.user_id IS NOT NULL
        THEN 'played'
      END AS type
    SQL
  end

  def self.game_list_columns
    <<~SQL
      (SELECT games.name FROM games WHERE user_games.game_id = games.id),
      (SELECT ratings.rating FROM ratings WHERE ratings.user_id = users.id AND ratings.game_id = user_games.game_id)
    SQL
  end

end