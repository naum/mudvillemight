require 'sinatra'
require 'sinatra/cookies'
require 'securerandom'
require_relative 'uba'

helpers do

  def calc_cookie_exp_time
    Time.now + (60 * 60 * 24 * 365)
  end

  def fetch_visitor_league(passkey)
    ofile = "storage/#{passkey}"
    if File.exist? ofile 
      Marshal.load IO.read(ofile) 
    else
      nil
    end
  end

  def gen_passkey
    # SecureRandom.uuid.upcase
    SecureRandom.rand(36 ** 8).to_s(36).upcase
  end

  def stash_visitor_league(passkey, vuba)
    ofile = "storage/#{passkey}"
    File.write ofile, Marshal.dump(vuba)
  end

end

get '/' do
  @keypass = cookies[:passkey9]
  @vuba = fetch_visitor_league(@keypass) if @keypass
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
  case params["op"]
  when "cancel"
    redirect '/info'
  when "create"
    exptime = calc_cookie_exp_time
    vpasskey = gen_passkey
    response.set_cookie(:passkey9, :value => vpasskey, :expires => exptime)
    @vuba = League.new
    stash_visitor_league vpasskey, @vuba
    redirect '/'
  end
end

