##
# This class wraps an org.dspace.content.Item object
describe DItem do
  before do
    DSpace.login('admin@localhost')
    communities = [DCommunity.create('Physics'), DCommunity.create('Music')]
    communities.each do |com|
      ['Dissertations', 'Theses', 'Faculty Papers'].each do |col|
        col_obj = DCollection.create(col, com)
        metadata = Hash.new
        metadata['dc.contributor.author'] = ["Einstein"]
        metadata['dc.type'] = 'Article'
        DItem.install(col_obj, metadata)
      end
    end
  end

  after do 
    DSpace.context_renew
  end

  describe '.iter' do
    it 'iterates through all Items in Dspace context' do
      expect(DItem.iter).to be_a(Java::OrgDspaceContent::ItemIterator)
    end
  end

  describe '.all' do
    it 'collects array of all archived item objects' do
      all_items = DItem.all
      expect(all_items.length).to eq(6) 
      expect(all_items).to include Java::OrgDspaceContent::Item
    end
  end

  describe '.find' do
    it 'gets corresponding Item object from a given id' do
      test_item = DItem.all[0]
      expect(DItem.find(test_item.id)).to eq(test_item)
    end

    it 'returns nil if item cannot be found' do
      expect(DItem.find(9999)).to be_nil
    end
  end

  describe '.inside' do
    it 'returns an empty array if given nil' do
      expect(DItem.inside(nil).length).to eq 0
    end

    it 'returns an Item in an array if given an Item' do
      item = DItem.all[0]
      expect(DItem.inside item).to eq [item]
    end

    it 'returns all items inside a given object' do
      com = DCommunity.all[0]
      inner_items = DItem.inside(com)
      expect(inner_items.length).to eq 3
      expect(inner_items).to include Java::OrgDspaceContent::Item
    end
  end

  describe '#bitstreams' do
  ## TESTING CURRENTLY UNSUPPORTED
  ##
  # Get the bitstreams in the given bundle.
  # 
  # @param bundle [String] bundle to search; if nil, get all.
  # @return [Array<org.dspace.content.Bitstream>] All bitstream 
  end

  describe '.install' do
  # Inherent in RSpec testing, and there is no error checking to test.
  ##
  # Creata a org.dspace.content.Item with the given metadata in the given 
  #   collection.
  #
  # @param collection [org.dspace.content.Collection] Collection in which to 
  #   place the Item.
  # @param metadata_hash [Hash] Item's metadata. (contains keys like 
  #   dc.contributir.author and single string or arrays of values)
  end
end
