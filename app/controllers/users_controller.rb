class UsersController < ApplicationController

  get '/signup' do
    if session[:user_id]
      redirect '/'
    end
    erb :'/users/signup'
  end

  post '/signup' do
    @user = User.create(params[:user])
    if @user.valid?
      session[:user_id] = @user.id
      redirect "/users/#{slug(@user.username)}"
    else
      redirect '/signup'
    end
  end

  get '/login' do
    if session[:user_id]
      redirect '/'
    end
    erb :'/users/login'
  end

  post '/login' do
    @user = User.find_by(username: params[:user][:username])
    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      redirect "/users/#{slug(@user.username)}"
    else
      redirect '/login'
    end
  end

  post '/logout' do
    session.clear
    redirect '/'
  end

  get '/users/:slug' do
    @user = User.find_by(username: unslug(params[:slug]))
    @game_list = Feed.game_list.where("users.username = '#{@user.username}'")
    @activities = Feed.activities.where("users.username = '#{@user.username}'")
    
    erb :'/users/show'
  end

  post "/users/:slug/" do
    if @current_user
      unless game = @current_user.games.find_by(params[:game])
        game = Game.find_by(params[:game]) || Game.create(params[:game])
        unplayed = true
      end
      rating = Rating.create(user_id: @current_user.id, game_id: game.id, rating: params[:rating]) if params[:rating]
      post = Post.create(user_id: @current_user.id, game_id: game.id, content: params[:post][:content], rating: rating) if params[:post][:content]
      UserGame.create(user_id: @current_user.id, game_id: game.id, post: post, rating: rating) if unplayed
      redirect "/users/#{slug(@current_user.username)}"
    end
  end

  get '/users/:slug/new' do
    if @user = User.find(session[:user_id])
      erb :'users/new'
    else
      redirect '/'
    end
  end

  get '/users/:slug/edit' do
    params[:activity].each { |key, value| params[:activity][key] = nil if value.empty? }
    if @activity = Feed.activities.find_by(params[:activity])
      erb :'users/edit'
    else
      redirect '/'
    end
  end

  patch '/users/:slug/' do
    params[:activity].each { |key, value| params[:activity][key] = nil if value.empty? }
    activity = Feed.activities.find_by(params[:activity])
    sql = <<~SQL
      ratings.id IS NOT NULL 
      AND (COALESCE (posts.created_at, user_games.created_at, ratings.created_at)) > '#{activity.created_at}'
      AND users.id = #{activity.user_id}
      AND games.id = #{activity.game_id}
    SQL
    current_rating = false if Feed.activities.find_by(sql)
    binding.pry
    # if activity && activity.user_id == session[:user_id]
      
    #   rating = Rating.find_by() ? rating.update() : rating = Rating.create()
        # post = yeahyeah
        # usergame = oops
    # end
  end

end