# myapp.rb
require 'rubygems'
require 'sinatra'
require 'active_record'
require 'models'
require 'erubis'
require 'json'

configure do
  # connect to SQLite3
  ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => "dbfile.sqlite3")
  
end

get '/' do
  'Hello world!'
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

