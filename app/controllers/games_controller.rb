class GamesController < ApplicationController

  get '/games' do
    erb :'/games/index'
  end
  
  get '/games/:slug' do
    @game = Game.find_by(name: unslug(params[:slug]))
    erb :'/games/show'
  end


end