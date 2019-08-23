class GamesController < ApplicationController

  get '/games' do
    erb :'/games/index'
  end
  
  get '/games/:slug' do
    @game = Game.find_by(name: unslug(params[:slug]))
    @activities = Feed.activities.where("games.name = '#{@game.name}'")
    @rating = Feed.game_rating.where("games.name = '#{@game.name}' AND ratings.current_rating = 'true'").average("ratings.rating")
    erb :'/games/show'
  end
  
  get '/games/:slug/new' do
    if @current_user && @game = Game.find_by(name: unslug(params[:slug]))
      erb :'games/new'
    else
      redirect '/'
    end
  end

  post "/games/:slug/" do
    if @current_user
      unless game = @current_user.games.find_by(name: unslug(params[:slug]))
        game = Game.find_by(name: unslug(params[:slug]))
        unplayed = true
      end
      if game
        rating = Rating.create(user_id: @current_user.id, game_id: game.id, rating: params[:rating]) if params[:rating]
        post = Post.create(user_id: @current_user.id, game_id: game.id, content: params[:post][:content], rating: rating) if params[:post][:content]
        UserGame.create(user_id: @current_user.id, game_id: game.id, post: post, rating: rating) if unplayed
        redirect "/games/#{slug(game.name)}"
      end
    end
  end


end