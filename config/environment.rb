require 'bundler/setup'
require 'require_all'
require 'sinatra'
require 'sinatra/activerecord'
require_all 'app'

set :database_file, './database.yml'