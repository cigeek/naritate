require 'sinatra'
require 'sinatra/reloader'

get '/' do

@foreign = File.read("foreign.html")
@japanese = File.read("japanese.html")

    erb :index
end

get '/about' do
	erb :about
end