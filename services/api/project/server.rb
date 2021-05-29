$:.unshift File.dirname(__FILE__)
require 'sinatra'
require 'lib/save_new_url'
require 'rack/throttle'

class Application < Sinatra::Base
  use Rack::Throttle::Minute, :max => 60
  # get sinatra to look at localhost
  set :bind, '0.0.0.0'
  get '/:slug' do
    set_cors_headers
    DB = Sequel.connect(ENV['DB_URL'])
    short_urls = DB[:short_urls] # Create a dataset
    found = short_urls.first(slug: params['slug'])
    response.headers['Location'] = found[:destination]
    status 301
  end

  options '/' do
    set_cors_headers
  end

  put '/' do
    set_cors_headers
    target_url = json_params['destination']
    begin
      slug = SaveNewUrl.new(target_url).save
      response.headers['Content-Location'] = "#{ENV['SERVER_URL']}/#{slug}"
      status 200
    rescue SaveNewUrl::InvalidURL
      status 422
      body "Invalid URL: #{target_url}"
    rescue SaveNewUrl::UnknownError
      status 422
      body "An unknown error occurred"
    end
  end

  def json_params
    JSON.parse(request.body.read)
  end

  def set_cors_headers
    if ENV['APP_ENV'] == 'development'
      response.headers['Access-Control-Allow-Origin'] = '*'
      response.headers['Access-Control-Expose-Headers'] = 'Content-Location'
      response.headers['Access-Control-Allow-Methods'] = 'GET,PUT,OPTIONS'
    end
  end
end
