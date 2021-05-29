$:.unshift File.dirname(__FILE__)
require 'sinatra'
require 'lib/save_new_url'
require 'rack/throttle'


class Application < Sinatra::Base
  if ['staging', 'production'].include?(ENV['APP_ENV'])
    use(
      Rack::Throttle::Minute,
      max: 100
    )
  end
  # get sinatra to look at localhost
  set :bind, '0.0.0.0'

  get '/redirects/:slug' do
    DB = Sequel.connect(ENV['DB_URL'])
    short_urls = DB[:short_urls] # Create a dataset
    found = short_urls.first(slug: params['slug'])
    response.headers['Location'] = found[:destination]
    status 301
  end

  options '/redirects' do
  end

  put '/redirects' do
    target_url = json_params['destination']
    begin
      slug = SaveNewUrl.new(target_url).save
      response.headers['Content-Location'] = "#{ENV['SERVER_URL']}/redirects/#{slug}"
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

  run! if app_file == $0
end
