describe DConfig do
  describe '.get' do
    it 'gets a configuration property' do
      expect(DConfig.get('dspace.baseUrl')).to_not be_nil
    end
  end
end