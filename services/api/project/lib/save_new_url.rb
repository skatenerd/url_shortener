require 'connection'
require 'generate_slug'

class SaveNewUrl
  def initialize(generate_slug=nil)
    @generate_slug = generate_slug || GenerateSlug.new
  end

  def save(url)
    begin
      record_count = (Connection::DB[:short_urls].order(:id).last || {})[:id] || 0
      slug = @generate_slug.for_record_count(record_count)
      slug_from_insert = Connection::DB[:short_urls].
        returning(:slug).
        insert_conflict(target: :destination).
        insert({destination: url, slug: slug}).dig(0, :slug)
      return slug_from_insert || lookup_slug_by_url(url)
    rescue Sequel::UniqueConstraintViolation
      save(url)
    end
  end

  private

  def lookup_slug_by_url(url)
    Connection::DB[:short_urls].first(destination: url)&.dig(:slug)
  end
end
