$:.unshift '/usr/src/app/project'
require 'rack/test'
require 'sinatra'
require 'server'

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  before(:each) do
    Connection::DB[:short_urls].delete
  end

  it "returns a short-url for a URL" do
    creation_response = put('/', {destination: 'www.google.com'}.to_json, { 'CONTENT_TYPE' => 'application/json' })
    short_url = creation_response.headers['Content-Location']
    redirect_for_slug_response = get(URI.parse(short_url).path)
    expect(redirect_for_slug_response.headers['Location']).to eql('http://www.google.com')

  end
end

