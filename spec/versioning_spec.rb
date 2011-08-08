require "spec_helper"

class VersionedItem
  include MongoMapper::EmbeddedDocument
end
class Versioned
  include MongoMapper::Document
  include MongoMapper::Plugins::Versioning
  key :title
  key :items, Array, :typecast => "VersionedItem", :default => []
  timestamps!
  attr_accessible :title
  versioning
end
describe Versioned do
  describe "Basic Usage" do
    it do
      v = Versioned.new :title => "Alpha"
      v.save!
      v.versions.should have(1).item
      v.update_attribute :title, "Beta"
      v.versions.should have(2).items
      v.versions.first.original.title.should == "Alpha"
    end
  end
  describe "Advanced Usage" do
    let(:today){ Date.new 2010, 1, 31 }
    let(:item1){ VersionedItem.new }
    let(:item2){ VersionedItem.new }
    let(:beta) do
      v = Versioned.new :title => "Beta"
      v.items << item1
      v.save!
      Timecop.freeze today+1
      v.items << item2
      v.save!
      v
    end
    before{ Timecop.freeze today }
    after{ Timecop.return }
    it "is versioned" do
      versions = beta.versions.all
      versions.should have(2).items
      versions[0].versioned_at.should eql today.to_time.utc
      versions[1].versioned_at.should eql (today+1).to_time.utc
      versions[0].original.should be_kind_of Versioned
      versions[0].original.items.should =~ [item1]
      versions[1].original.items.should =~ [item1, item2]
    end
    it "allows for subquery on versions" do
      specific_versions = beta.versions.where(:versioned_at.lte => today.to_time.utc).all
      specific_versions.should have(1).item
      specific_versions.first.original.items.should =~ [item1]
    end
  end
end