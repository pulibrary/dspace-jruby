describe DConstants do
  describe '.typeStr' do
    it 'returns the corresponding type string for an object id' do
      expect(DConstants.typeStr(1)).to eq('Bundle')
    end
  end

  describe '.actionStr' do
    it 'Return the corresponding type string for an action id' do
      expect(DConstants.actionStr(1)).to eq('WRITE')
    end
  end
end
