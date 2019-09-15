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
      @errors = @user.errors.messages
      erb :'/users/signup'
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
      @error = true
      erb :'/users/login'
    end
  end

  post '/logout' do
    session.clear
    redirect '/'
  end

  get '/users/:slug' do
    @user = User.find_by(username: unslug(params[:slug]))
    @game_list = Activity.game_list.where("activities.user_id = '#{@user.id}'")
    @activities = Activity.feed.where("activities.user_id = '#{@user.id}'")
    
    erb :'/users/show'
  end

  get '/users/:slug/edit' do
    params[:activity].each { |key, value| params[:activity][key] = nil if value.empty? }
    if @activity = Activity.feed.find_by(params[:activity])
      erb :'users/edit'
    else
      redirect '/'
    end
  end

end