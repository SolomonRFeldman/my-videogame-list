class Feed
  
  def self.activities
    UserGame
      .joins("FULL JOIN posts ON user_games.post_id = posts.id")
      .select(columns)
      .order(created_at: :desc)
      .limit(10)
  end


  private
  
  def self.columns
    <<~SQL
      coalesce (posts.user_id, user_games.user_id) AS user_id,
      posts.content AS post_content,
      coalesce (posts.game_id, user_games.game_id) AS game_id,
      coalesce (posts.created_at, user_games.created_at) AS created_at,
      COALESCE (
        (SELECT games.name FROM games WHERE user_games.game_id = games.id),
        (SELECT games.name FROM games WHERE posts.game_id = games.id)
      ) AS game_name,
      COALESCE (
        (SELECT users.username FROM users WHERE user_games.user_id = users.id),
        (SELECT users.username FROM users WHERE posts.user_id = users.id)
      ) AS username,
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

end