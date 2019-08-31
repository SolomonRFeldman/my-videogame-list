class ActivitiesController < ApplicationController

  get '/activities/new' do
    if @current_user
      erb :'/activities/new'
    else
      redirect '/'
    end
  end

  post "/activities" do
    if @current_user
      unless game = @current_user.games.find_by(params[:game])
        game = Game.find_by(params[:game]) || Game.create(params[:game])
        params[:activity][:played] = true
      end
      if game.valid?
        params[:activity][:user_id] = @current_user.id
        params[:activity][:game_id] = game.id
        Activity.create(params[:activity])
        redirect "/users/#{slug(@current_user.username)}"
      end
      redirect "/users/#{slug(@current_user.username)}/new?emptygame=true"
    end
    redirect '/'
  end

end