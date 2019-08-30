require './config/environment'
use Rack::MethodOverride
use GamesController
use ActivitysController
use UsersController
run ApplicationController