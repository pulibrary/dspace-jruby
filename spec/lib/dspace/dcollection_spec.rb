describe DCollection do
  subject { described_class.create('Junior Papers', DCommunity.all()[0]) }

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

  describe '.all' do
    it 'retrieves all collections within context' do
      all_cols = DCollection.all
      expect(all_cols.length).to eq 6
      expect(all_cols).to include Java::OrgDspaceContent::Collection
    end
  end

  describe '.find' do
    it 'gets collection by id' do
      expect(DCollection.find(subject.id)).to eq subject
    end

    it 'returns nil if collection cannot be found' do
      expect(DCollection.find 99999).to be_nil
    end
  end

  describe '.create' do
    it 'creates a java collection' do
      col = DCollection.create('test-collection', DCommunity.all()[0])
      expect(col).to be_a Java::OrgDspaceContent::Collection
    end
  end

  describe '#items' do
    it 'returns an appropriately sized array of Item objects' do
      items = DSpace.create(DCollection.all[0]).items
      expect(items.length).to eq 1
      expect(items).to include Java::OrgDspaceContent::Item
    end
  end
end
