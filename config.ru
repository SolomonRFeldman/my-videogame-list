require './config/environment'
use Rack::MethodOverride
use GamesController
use ActivitiesController
use UsersController
run ApplicationController