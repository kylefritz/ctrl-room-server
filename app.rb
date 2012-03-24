require 'sinatra'
require 'ohm'
require 'json'

set :static, true
set :public_folder, "#{File.dirname(__FILE__)}/public"

before do
 if ENV['REDISTOGO_URL']
   Ohm.connect :url => ENV['REDISTOGO_URL']
 else
   Ohm.connect
 end
end


get '/' do
  @users = User.all.all
  #server list of users
  erb :index 
end


get '/events/:user_id' do
  @user=User.find(:email =>params[:user_id]).all[0]
  
  if @user.nil?
  	return 404
  end
  
  
  #events for this user
  erb :events 
end

#
# {project_name:"",project_path:"",file_path:"" }
#
#
#

post '/message/:user_id' do  
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
  event.date = Time.now.getlocal
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
  def to_hash
    super.merge(:path => path,:date => date)
  end
end
class Project < Ohm::Model
  attribute :name
  attribute :path
  collection :events, Event

  
  index :name
  index :path
  reference :user, User
  
  def to_hash
    super.merge(:name => name,:path => path, :events => events.all)
  end
end
class User < Ohm::Model
  attribute :email
  collection :projects, Project

  
  index :email
  
  def to_hash
    super.merge(:email => email, :projects => projects.all)
  end
end


