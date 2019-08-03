require './config/environment'
use Rack::MethodOverride
use GamesController
use PostsController
use UsersController
run ApplicationController