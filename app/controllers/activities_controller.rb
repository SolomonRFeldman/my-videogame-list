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

  get '/activities/:id/edit' do
    @activity = Feed.activities.find_by(id: params[:id])
    redirect_if_not_authorized(@activity)
    erb :'/activities/edit'
  end

  patch '/activities/:id' do
    activity = Activity.find_by(id: params[:id])
    redirect_if_not_authorized(activity)
    activity.edit_activity(params[:activity])
    redirect "/users/#{slug(@current_user.username)}"
  end

  delete '/activities/:id' do
    activity = Activity.find_by(id: params[:id])
    redirect_if_not_authorized(activity)
    activity.played ? Activity.where("user_id = #{activity.user_id} AND game_id = #{activity.game_id}").destroy_all : activity.destroy
    redirect "/users/#{slug(@current_user.username)}"
  end
    
  helpers do

    def redirect_if_not_authorized(activity)
      unless activity && activity.user_id == session[:user_id]
        redirect '/'
      end
    end

  end

end