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
    @games = @user.games
    @posts = Post.where(game_id: @user.games.select(:id))
    
    erb :'/users/show'
  end

  post '/users/:slug' do
    if user = User.find(session[:user_id])
      if !user.games.find_by(params[:game])
        game = Game.find_by(params[:game]) || Game.create(params[:game])
        user.games << game
      else
        redirect "/users/#{params[:slug]}/new"
      end
      Post.create(user_id: user.id, game_id: game.id, content: params[:post][:content])
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