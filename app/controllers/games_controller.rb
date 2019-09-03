class GamesController < ApplicationController
  
  get '/games/:slug' do
    @game = Game.find_by(name: unslug(params[:slug]))
    @activities = @game.activities.feed
    @rating = Activity.game_rating(@game.id)
    erb :'/games/show'
  end

end