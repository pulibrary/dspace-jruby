describe DMetadataSchema do
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
    it 'Gets all MetaDataSchema within Dspace context' do
      all_dms = DMetadataSchema.all
      expect(all_dms.length).to eq 3
      expect(all_dms).to include Java::OrgDspaceContent::MetadataSchema
    end
  end

  describe '#fields' do
    it 'Get all MetaDatafields within a schema' do
      dms = DSpace.create(DMetadataSchema.all[0])
      mdfields = dms.fields
      expect(mdfields.length).to eq 73 # this is lazy
      expect(mdfields).to include Java::OrgDspaceContent::MetadataField
    end
  end
end