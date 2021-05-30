require 'sequel'
require 'save_new_url'

describe SaveNewUrl do
  before(:each) do
    Connection::DB[:short_urls].delete
  end

  it "saves a url" do
    expect {
      SaveNewUrl.new("http://yes.com").save
    }.to change {
      Connection::DB[:short_urls].count
    }.from(0).to(1)

    saved = Connection::DB[:short_urls].order(:id).last
    expect(saved[:destination]).to eql("http://yes.com")
  end

  it "complains on nonsense url" do
    expect {
      SaveNewUrl.new("nonsenseurl").save
    }.to raise_error(SaveNewUrl::InvalidURL)
  end

  it "raises UnknownError if it runs out of attempts making random slugs" do
    Connection::DB[:short_urls].insert({destination: "some other url", slug: "crash"})
    slug_generator = double(:slug_generator)
    allow(slug_generator).to receive(:for_record_count) { "crash" }
    expect {
      SaveNewUrl.new("http://www.itwillcrash.org", slug_generator).save
    }.to raise_error(SaveNewUrl::UnknownError)
  end

  it "does nothing if the url has already been saved" do
    SaveNewUrl.new("yes.com").save
    expect {
      SaveNewUrl.new("yes.com").save
    }.not_to change {
      Connection::DB[:short_urls].count
    }
  end

  it "returns a usable slug" do
    slug = SaveNewUrl.new("http://yes.com").save
    expect(Connection::DB[:short_urls].first(slug: slug)[:destination]).to eql("http://yes.com")
  end

  it "retries on slug collision" do
    Connection::DB[:short_urls].insert({destination: "some other url", slug: "crash"})
    slug_generator = double(:slug_generator)
    expect(slug_generator).to receive(:for_record_count).and_return("crash", "crash", "crash", "win")

    SaveNewUrl.new("yes.com", slug_generator).save
  end


  it "returns a usable slug on URL collision" do
    first_slug = SaveNewUrl.new("yes.com").save
    second_slug = SaveNewUrl.new("yes.com").save
    expect(second_slug).to eql(first_slug)
  end

  it "prepends a url-scheme to the url if missing" do
    slug = SaveNewUrl.new("yes.com").save
    expect(Connection::DB[:short_urls].first(slug: slug)[:destination]).to eql("http://yes.com")
  end
end
