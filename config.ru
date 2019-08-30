require './config/environment'
use Rack::MethodOverride
use GamesController
use ActivityController
use UsersController
run ApplicationController