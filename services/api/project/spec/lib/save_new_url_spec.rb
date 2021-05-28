require 'sequel'
require 'save_new_url'

describe SaveNewUrl do
  before(:each) do
    Connection::DB[:short_urls].delete
  end

  it "saves a url" do
    expect {
      SaveNewUrl.new.save("yes.com")
    }.to change {
    Connection::DB[:short_urls].count
    }.from(0).to(1)

    saved = Connection::DB[:short_urls].order(:id).last
    expect(saved[:destination]).to eql("yes.com")
  end

  it "does nothing if the url has already been saved" do
    SaveNewUrl.new.save("yes.com")
    expect {
      SaveNewUrl.new.save("yes.com")
    }.not_to change {
      Connection::DB[:short_urls].count
    }
  end

  it "returns a usable slug" do
    slug = SaveNewUrl.new.save("yes.com")
    expect(Connection::DB[:short_urls].first(slug: slug)[:destination]).to eql("yes.com")
  end

  it "retries on slug collision" do
    Connection::DB[:short_urls].insert({destination: "some other url", slug: "crash"})
    slug_generator = double(:slug_generator)
    expect(slug_generator).to receive(:for_record_count).and_return("crash", "crash", "crash", "win")

    SaveNewUrl.new(slug_generator).save("yes.com")
  end


  it "returns a usable slug on URL collision" do
    first_slug = SaveNewUrl.new.save("yes.com")
    second_slug = SaveNewUrl.new.save("yes.com")
    expect(second_slug).to eql(first_slug)
  end
end
