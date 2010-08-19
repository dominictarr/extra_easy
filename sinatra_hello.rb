require 'rubygems'
require 'sinatra'

get '/' do
  "Hello World FROM SINATRA!"
end
get '/meet' do
  "Hello #{params[:name]}!"
end
