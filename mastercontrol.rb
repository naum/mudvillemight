require 'sinatra'
require 'sinatra/cookies'
require 'securerandom'
require_relative 'uba'

helpers do

  def calc_cookie_exp_time
    Time.now + (60 * 60 * 24 * 365)
  end

  def gen_passkey
    # SecureRandom.uuid.upcase
    SecureRandom.rand(36 ** 8).to_s(36).upcase
  end

end

get '/' do
  @uba = League.new
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
  erb :genesis
end

post '/genesis' do
  exptime = calc_cookie_exp_time
  response.set_cookie(:passkey9, :value => gen_passkey(), :expires => exptime)
  "Yeah, we received the stupid form. Input: #{params.to_s}"
end

