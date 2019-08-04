class GamesController < ApplicationController

  get '/games' do
    erb :'/games/index'
  end

  get '/games/new' do
    if session[:user_id]
      erb :'games/new'
    else
      redirect '/'
    end
  end

  post '/games' do    
    if user = User.find(session[:user_id])
      if !user.games.find_by(params[:game])
        game = Game.find_by(params[:game]) || Game.create(params[:game])
        user.games << game
        redirect "/users/#{slug(user.username)}"
      else
        redirect '/games/new'
      end
    end
  end

  get '/games/:slug' do
    @game = Game.find_by(name: unslug(params[:slug]))
    erb :'/games/show'
  end


end