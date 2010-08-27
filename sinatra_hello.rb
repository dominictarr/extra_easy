require 'rubygems'
require 'sinatra'
class HelloSinatra < Sinatra::Base

get '/' do
  "Hello World FROM SINATRA!"
end
get '/meet' do
  "Hello #{params[:name]}!"
end

end
