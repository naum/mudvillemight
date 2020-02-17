require 'sinatra'
require 'sinatra/cookies'

get '/' do
  erb :index
end

get '/about' do
  erb :about
end

get '/genesis' do
  cookies[:joyticket] = '71 Pirates'
  erb :genesis
end

post '/genesis' do
end

