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
  erubis :projects
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

