require 'bundler/setup'
require 'require_all'
require 'sinatra'
require 'sinatra/activerecord'
require 'pry'
require_all 'app'

set :database_file, './database.yml'