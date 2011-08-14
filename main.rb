# myapp.rb
require 'rubygems'
require 'sinatra'
require 'active_record'
require 'models'
require 'erubis'
require 'json'
require 'rack/methodoverride'

#################################################
#
# Configuration
#
configure do
  # DB connections
  ActiveRecord::Base.establish_connection(YAML::load(File.open('config/database.yml'))["development"]) 
  
  # Allow browser forms to simulate DELETE by adding '_method=delete' to the URL
  set :method_override, true
end

#################################################
#
# Helper methods
#
helpers do
  
  # Return true if object is not nil & can be converted to an integer
  def is_integer?(object)
    true if !object.nil? && Integer(object) rescue false
  end
  
  def to_integer(object, default_value)
    if is_integer? object
      Integer(object)
    else
      Integer(default_value)
    end
  end
  
  def min_and_max(number, min, max)
    number = min if number < min
    number = max if number > max
    number
  end
end

#################################################
#
# Routes
#
get '/' do
  'dynamic forms works. <a href="/projects">Projects</a>'
end

################################
#
#  Project resource
#
#  URL namespace is /projects
#

#
# GET /projects?q=<search>&limit=<rows>&offset=<offset>
#
# Retrieve a list of Projects.
#
get '/projects' do
  q = request.params['q'] || ''
  limit = min_and_max(to_integer(request.params['limit'], 20), 1, 100) 
  offset = min_and_max(to_integer(request.params['offset'], 0), 0, 1_000_000_000) 
  puts "q=[#{q}] limit=[#{limit}] offset=[#{offset}]"
  projects = Project.find_by_name_paginated(q, limit, offset)
  erubis :'project/list', 
         :locals => { :q => q, :limit => limit, :offset => offset, :projects => projects }
end

#
# GET /projects/<id>
#
# Retrieve a Project, presented in a format suitable for editing.
#
get '/projects/:id' do
  project = Project.find(params[:id])
  erubis :'project/edit', 
         :locals => { :project => project }
end

#
# PUR /projects/<id>
#
# Replace a Project
#
put '/projects/:id' do
  project = Project.find(params[:id])
  project.attributes = params.delete_if {|key, value| key == '_method'}
  project.save!
  # TODO - Notify of success - how?  
  "OK <a href='/projects'>Return to list</a>"
end




get '/projects/add' do
  add_edit_project
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

