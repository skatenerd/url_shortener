require 'generate_slug'
require 'sequel'

describe GenerateSlug do
  it "has a minimum length of 4" do
    expect(GenerateSlug.new.for_record_count(1).length).to eql(4)
  end

  it "does not crash for 0 records" do
    expect(GenerateSlug.new.for_record_count(0).length).to eql(4)
  end


  it "has less than a 1/1000 probability of collision" do
    record_count = 64 ** 8
    slug = GenerateSlug.new.for_record_count(record_count)
    slug_chose_from = (64 ** slug.length)
    expect(record_count.to_f / slug_chose_from.to_f).to be <= 0.001
  end
end
