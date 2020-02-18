require 'sinatra'
require 'sinatra/cookies'
require_relative 'uba'

helpers do

  def calc_cookie_exp_time
    Time.now + (3600 + 24 * 360)
  end

end

get '/' do
  erb :index
end

get '/about' do
  erb :about
end

get '/info' do
  @keypass = cookies[:joyticket3]
  np = Namepool.new()
  wordlist = []
  20.times do 
    wordlist << np.draw()
  end
  @namedump = wordlist.join("<br>\n")
  erb :info
end

get '/genesis' do
  exptime = calc_cookie_exp_time
  response.set_cookie(:joyticket3, :value => '60 Pirates', :expires => exptime)
  erb :genesis
end

post '/genesis' do
end

