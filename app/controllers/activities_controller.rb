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
    if @activity && @activity.user_id == session[:user_id]
      erb :'/activities/edit'
    else
      redirect '/'
    end
  end

  patch '/activities/:id' do
    activity = Activity.find_by(id: params[:id])
    if activity && activity.user_id == session[:user_id]
      activity.edit_activity(params[:activity])
      redirect "/users/#{slug(@current_user.username)}"
    else
      redirect '/'
    end
  end

  delete '/activities/:id' do
    activity = Activity.find_by(id: params[:id])
    if activity && activity.user_id == session[:user_id]
      activity.played ? Activity.where("user_id = #{activity.user_id} AND game_id = #{activity.game_id}").destroy_all : activity.destroy
    end
    redirect "/users/#{slug(@current_user.username)}"
  end

end