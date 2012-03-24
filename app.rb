require 'sinatra'
require 'ohm'

set :static, true
set :public_folder, "#{File.dirname(__FILE__)}/public"

get '/' do
  #server list of users
  erb :index 
end


get '/event/:user_id' do
  #events for this user
  erb :index 
end



post '/message/:user_id' do
  #recieve messages from watcher
  #save to db
end