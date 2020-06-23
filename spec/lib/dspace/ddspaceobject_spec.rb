describe DDSpaceObject do
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

  describe '#parents' do
    it 'returns all parents, grandparents, etc. from Dspace object' do
      dso_parents = DSpace.create(DItem.all()[0]).parents
      expect(dso_parents).to include Java::OrgDspaceContent::Community
      expect(dso_parents).to include Java::OrgDspaceContent::Collection
    end

    it 'returns an empty list if there are no parents' do
      com = DSpace.create(DCommunity.all()[0])
      expect(com.parents.length).to eq 0
    end
  end

  describe '#isInside' do
    it 'returns true if DSO is within given DSpace object' do
      dso_item = DSpace.create(DItem.all()[0])
      dso_parent = dso_item.parents[0]
      expect(dso_item.isInside(dso_parent)).to be true
    end

    it 'returns false if DSO is outside given DSpace object' do
      dso_item = DSpace.create(DItem.all()[0])
      new_com = DCommunity.create('new-test-community')
      expect(dso_item.isInside(new_com)).to be false
    end
  end

  describe '#policies' do
    it 'returns a hash of actions and hashes' do 
      dso_item = DSpace.create(DItem.all()[0])
      expect(dso_item.policies).to be_a Array
    end
  end

  describe '#getMetaDataValues' do
    it 'returns a hash of metadata values' do 
      dso_item = DSpace.create(DItem.all()[0])
      expect(dso_item.policies).to be_a Array
    end
  end

end
