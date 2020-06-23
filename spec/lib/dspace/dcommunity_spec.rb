describe DCommunity do
  subject { described_class.create('Classics') }

  before do
    DSpace.login('admin@localhost')
    communities = [DCommunity.create('Physics'), DCommunity.create('Music')]
    communities.each do |com|
      ['Dissertations', 'Theses', 'Faculty Papers'].each do |col|
        DCollection.create(col, com)
      end
    end
  end

  after do 
    DSpace.context_renew
  end

  describe '.all' do
    it 'returns all communities in the contest' do
      expect(DCommunity.all().length).to eq(2)
    end
  end

  describe '.find' do
    it 'gets community by id' do
      DCommunity.find(subject.id) === subject
    end

    it 'returns nil if community cannot be found' do
      expect(DCommunity.find(99999)).to be_nil
    end
  end

  describe '.create' do
    it 'creates a java community' do
      expect(DCommunity.create('test')).to be_a(Java::OrgDspaceContent::Community)
    end
  end

  describe '#getCollections' do
    it 'get collections from community' do
      com = DCommunity.all()[0]
      expect(DSpace.create(com).getCollections.length).to eq(3)
    end
  end

  describe '.getCollections' do
    # NOTE: Unable to place communities within communities, so full functionality
    #   cannot be tested
    it 'get all collections from within given community' do
      com = DCommunity.all()[0]
      expect(DCommunity.getCollections(com).length).to eq(3)
    end
  end
end
