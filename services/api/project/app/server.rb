# server.rb
require 'sinatra'
require 'securerandom'
require 'sequel'

# get sinatra to look at localhost
set :bind, '0.0.0.0'

get '/:slug' do
  response.headers['Access-Control-Allow-Origin'] = 'localhost'
  DB = Sequel.connect(ENV['DB_URL'])
  short_urls = DB[:short_urls] # Create a dataset
  found = short_urls.first(slug: params['slug'])
  response.headers['Location'] = found[:destination]
  status 301
end

options '/' do
  response.headers['Access-Control-Allow-Origin'] = '*'
  response.headers['Access-Control-Allow-Methods'] = 'GET,PUT,OPTIONS'
end

put '/' do
  # TODO: CORS is getting spread aroudn everywhere, clean it up
  response.headers['Access-Control-Allow-Origin'] = '*'
  response.headers['Access-Control-Expose-Headers'] = 'Content-Location'
  json_params = JSON.parse(request.body.read)
  DB = Sequel.connect(ENV['DB_URL'])
  short_urls = DB[:short_urls] # Create a dataset
  slug = SecureRandom.hex(10)
  short_urls.insert(:destination => json_params["destination"], :slug => slug)
  response.headers['Content-Location'] = "http://localhost:4567/#{slug}"
  status 200
end

