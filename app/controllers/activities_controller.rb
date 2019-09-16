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
      build_activity ? (redirect "/users/#{slug(@current_user.username)}") : (erb :'/activities/new')
    else
      redirect '/'
    end
  end

  get '/activities/:id/edit' do
    @activity = Activity.feed.find_by(id: params[:id])
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
    activity.played ? activity.associated.destroy_all : activity.destroy
    redirect "/users/#{slug(@current_user.username)}"
  end
    
  helpers do

    def redirect_if_not_authorized(activity)
      unless activity && activity.user_id == session[:user_id]
        redirect '/'
      end
    end

    def build_activity
      unless @game = @current_user.games.find_by(params[:game])
        @game = Game.find_by(params[:game]) || Game.create(params[:game])
        params[:activity][:played] = true
      end
      @activity = Activity.new(params[:activity])
      @activity.update(game_id: @game.id, user_id: @current_user.id)
    end

  end

end