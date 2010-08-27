require 'rubygems'
require 'sinatra'
class HelloSinatra < Sinatra::Base

get '/' do
  "Hello World FROM SINATRA!" +
  "\n\n" + 
  ENV['DATABASE_URL']
end
get '/meet' do
  "Hello #{params[:name]}!"
end

end
