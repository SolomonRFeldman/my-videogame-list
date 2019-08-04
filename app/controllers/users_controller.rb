class UsersController < ApplicationController

  get '/signup' do
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
    erb :'/users/login'
  end

  get '/users/:slug' do
    
  end

end