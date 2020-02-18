require 'sinatra'
require 'sinatra/cookies'
require 'securerandom'
require_relative 'uba'

helpers do

  def calc_cookie_exp_time
    Time.now + (3600 + 24 * 360)
  end

  def gen_passkey
    SecureRandom.alphanumeric(12).upcase
  end

end

get '/' do
  erb :index
end

get '/about' do
  erb :about
end

get '/info' do
  @keypass = cookies[:passkey9]
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
  response.set_cookie(:passkey9, :value => gen_passkey(), :expires => exptime)
  erb :genesis
end

post '/genesis' do
end

