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

end