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


end