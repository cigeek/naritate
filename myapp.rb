require 'sinatra'

get '/' do

@foreign = File.read("foreign.dat")
@japanese = File.read("japanese.dat")

    erb :index
end

get '/about' do
	erb :about
end