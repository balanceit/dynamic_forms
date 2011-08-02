# myapp.rb
require 'rubygems'
require 'sinatra'
require 'active_record'
require 'models'
require 'erubis'
require 'json'

configure do
  ActiveRecord::Base.establish_connection(YAML::load(File.open('config/database.yml'))["development"]) 
end

get '/' do
  'dynamic forms works. <a href="/projects">Projects</a>'
end

get '/projects' do
  erubis :'project/list'
end

get '/projects/add' do
  project = Project.new
  erubis :'project/edit', :locals => { :project => project }
end

post '/projects' do
  project = Project.new(:name => request.POST['name']);
  project.save
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

