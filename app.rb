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

#
# {project_name:"",project_path:"",file_path:"" }
#
#
#

post '/message/:user_id' do
  Ohm.connect
  
  #find user
  user_id=params[:user_id]
  user = User.find(:email => user_id).all[0]
  if user.nil?
  	user = User.create(:email=>user_id)
  end
  
  #find project
  project_name = params[:project_name]
  project = user.projects.find(:name => project_name).all[0]
  if project.nil?
  	project = Project.create(:name=>project_name)
  	project.path=params[:project_path]
  	project.user=user
  	project.save
  end
  
  event=Event.new
  event.path = params[:file_path]
  event.project = project
  event.date = Time.now.strftime('%Y-%jT%T%:z')
  event.save
  #recieve messages from watcher
  #save to db
end

class Event < Ohm::Model
  attribute :path
  attribute :date


  index :path
  index :date
  reference :project, Project
  
end
class Project < Ohm::Model
  attribute :name
  attribute :path
  collection :events, Event

  
  index :name
  index :path
  reference :user, User
end
class User < Ohm::Model
  attribute :email
  collection :projects, Project

  
  index :email
end


