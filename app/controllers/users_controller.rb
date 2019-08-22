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
    @username = unslug(params[:slug])
    @game_list = Feed.game_list.where("users.username = '#{@username}'")
    @activities = Feed.activities.where("users.username = '#{@username}'")
    
    erb :'/users/show'
  end

  post "/users/:slug/" do
    if user = User.find(session[:user_id])
      game = user.games.find_by(params[:game])
      if game == nil
        game = Game.find_by(params[:game]) || Game.create(params[:game])
        user_game = UserGame.create(user_id: user.id, game_id: game.id)
      end
      post = Post.create(user_id: user.id, game_id: game.id, content: params[:post][:content])
      if post.valid? && user_game
        post.user_game = user_game 
        post.save
      end
      rating = Rating.create(user_id: user.id, game_id: game.id, rating: params[:rating])
      if rating.valid?
        rating.post = post if post.valid?
        rating.user_game = user_game if user_game
        if old_rating = Rating.find_by(user_id: user.id, game_id: game.id, current_rating: true)
          old_rating.current_rating = false
          old_rating.save
        end
        rating.current_rating = true
        rating.save
      end
      redirect "/users/#{slug(user.username)}"
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