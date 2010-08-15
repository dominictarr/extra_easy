require 'rubygems'
require 'sinatra'

get '/' do
  "Hello World!"
end
get '/meet' do
  "Hello #{params[:name]}!"
end
