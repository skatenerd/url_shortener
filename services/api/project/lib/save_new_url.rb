require 'uri'
$:.unshift File.dirname(__FILE__)
require 'connection'
require 'generate_slug'
require 'sequel'
require 'public_suffix'

class SaveNewUrl
  class InvalidURL < ArgumentError
  end

  class UnknownError < RuntimeError
  end

  def initialize(url, generate_slug=nil)
    @url = url
    @generate_slug = generate_slug || GenerateSlug.new
  end

  def save(tries=10)
    unless valid_url?
      raise InvalidURL
    end

    unless tries > 0
      raise UnknownError
    end

    begin
      record_count = (Connection::DB[:short_urls].order(:id).last || {})[:id] || 0
      slug = @generate_slug.for_record_count(record_count)
      slug_from_insert = Connection::DB[:short_urls].
        returning(:slug).
        insert_conflict(target: :destination).
        insert({destination: preprocessed_url, slug: slug}).dig(0, :slug)
      return slug_from_insert || lookup_slug_by_url
    rescue Sequel::UniqueConstraintViolation
      save(tries - 1)
    end
  end

  private

  attr_reader :generate_slug

  def lookup_slug_by_url
    Connection::DB[:short_urls].first(destination: preprocessed_url)&.dig(:slug)
  end

  def valid_url?
    begin
      PublicSuffix.parse(url_no_scheme)
      true
    rescue PublicSuffix::Error => e
      false
    end
  end

  def url_no_scheme
    parsed = URI.parse(@url)
    (parsed.host || '') + (parsed.path || '')
  end


  def preprocessed_url
    u = URI.parse(@url)
    if u.scheme
      @url
    else
      "http://#{@url}"
    end
  end

end
