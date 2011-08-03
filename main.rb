# myapp.rb
require 'rubygems'
require 'sinatra'
require 'active_record'
require 'models'
require 'erubis'
require 'json'
require 'rack/methodoverride'

#
# Configuration
#
configure do
  # DB connections
  ActiveRecord::Base.establish_connection(YAML::load(File.open('config/database.yml'))["development"]) 
  
  # Allow browser forms to simulate DELETE by adding '_method=delete' to the URL
  set :method_override, true
end

#
# Helper methods
#
helpers do
  def add_edit_project(id=nil)
    if id
      project = Project.find(id)
    else
      project = Project.new
    end
    erubis :'project/edit', :locals => { :project => project }
  end
end

#
# Routes
#
get '/' do
  'dynamic forms works. <a href="/projects">Projects</a>'
end

get '/projects' do
  erubis :'project/list'
end

get '/projects/add' do
  add_edit_project
end

get '/projects/:id' do
  add_edit_project(params[:id])
end

post '/projects/:id' do
  project = Project.find(params[:id])
  project.attributes = params
  project.save!
  # TODO - Notify of success - how?  
  "OK <a href='/projects'>Return to list</a>"
end

delete '/projects/:id' do
  project = Project.find(params[:id])
  project.delete
  # TODO - Notify of success - how?  
  "OK <a href='/projects'>Return to list</a>"
end

post '/projects' do
  project = Project.new(:name => request.POST['name']);
  project.save!
  redirect '/projects'
end

get '/projects.json' do
  result = {
    'projects' => [],
    'total'   => 0,
    'success' => true,
  }
  
  Project.find(:all).each do |project|
    result['projects'] << project
    result['total'] = result['total'] + 1
  end
  
  result.to_json
end

