class GamesController < ApplicationController
  
  get '/games/:slug' do
    @game = Game.find_by(name: unslug(params[:slug]))
    @activities = Feed.activities.where("games.name = '#{@game.name}'")
    @rating = Activity.where("game_id = '#{@game.id}' AND current_rating = 'true'").average("rating")
    erb :'/games/show'
  end

end