require './config/environment'
require 'sinatra'
class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "testing_secret"
  end
  
  before '/*' do
    @current_user = User.find(session[:user_id])
  end

  get '/' do
    erb :index
  end

  def slug(string)
    string.gsub(' ', '-')
  end

  def unslug(slug)
    slug.gsub('-', ' ')
  end

end